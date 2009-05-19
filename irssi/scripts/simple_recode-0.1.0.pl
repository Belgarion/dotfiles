#
#  Simple Recode (irssi) 0.1.0
#
#  (c) 2000-2004 by Robert Scheck <irssi@robert-scheck.de>
#
#  Simple Recode is adapted from "recode_ion.pl" and "recode.pl", a
#  simple charset converting script, that converts all text to the
#  specified charset.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc.,
#  59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#


use 5.6.1;
use strict;
use warnings;
use Data::Dumper qw();
use Irssi qw();
use IO::File qw();
use POSIX qw();
use Text::Iconv qw();
use Irssi 20020324;


use vars qw($VERSION %IRSSI);
$VERSION = "0.1.0";
%IRSSI = (
    authors     => "Robert Scheck",
    contact     => "irssi\@robert-scheck.de",
    name        => "Simple Recode",
    description => "Converts all text to the specified charset",
    license     => "GNU GPL v2",
    url         => "http://ftp.robert-scheck.de/linux/irssi/scripts/",
    modules     => "Text::Iconv",
    changed     => "$VERSION",
    commands    => "recode"
);

our %global = ();

# Set the charset all text is converted to, for e.g. utf-8, iso-8859-1
$global{'charset'} = "iso-8859-1";

Irssi::command_bind(
    'recode' => sub {
            Irssi::print("Converting all charsets to: " . $global{'charset'});
    }
);

# Wrapper from the original recode.pl (by Marcin Kowalczyk, Timo Sirainen and Taneli Kaivola)
$global{'workersPre'}  = {};
$global{'workersPost'} = {};
$global{'locks'}       = {};
$global{'lastOwnMsg'}  = undef;

sub signalWrapper {
    my $signal = Irssi::signal_get_emitted();
    return if $global{'locks'}{$signal};
    $global{'workersPre'}{$signal}->(@_) or return;
    $global{'locks'}{$signal} = 1;
    Irssi::signal_emit($signal, @_);
    delete $global{'locks'}{$signal};
    $global{'workersPost'}{$signal}->(@_);
    Irssi::signal_stop();
}

sub signalAddGood {
    my ($signal, $workerPre, $workerPost) = @_;
    $global{'workersPre'}{$signal} = $workerPre;
    $global{'workersPost'}{$signal} = $workerPost || sub { };
    Irssi::signal_add_first($signal, \&signalWrapper);
}

sub convertIn {
    my ($input, $chatnet, $target) = @_;
    my $output;

    $input   = "" unless defined $input;
    $chatnet = defined($chatnet) ? lc($chatnet) : "";
    $target  = defined($target)  ? lc($target)  : "";

    # !channels
    $target =~ s/^![0-9a-z]{5}/!/;

    # %alreadyTried: Don't try to do the same conversion twice
    my %alreadyTried;

    # Try these conversions
    my @conversions;
    push @conversions, [ "utf-8", $global{'charset'} ];
    my $targetCharset;

    if($targetCharset = $global{'charset'})
    {
        push @conversions, [ $targetCharset, $global{'charset'} ];
    }
    push @conversions,
      [ $global{'charset'}, $global{'charset'} ];

    foreach (@conversions) {
        next if $alreadyTried{"$_->[0] $_->[1]"};
        $alreadyTried{"$_->[0] $_->[1]"} = 1;
        $global{'iconvDep'}{"$_->[0] $_->[1]"} ||=
          Text::Iconv->new($_->[0], "$_->[1]//translit")
          || die qq|Text::Iconv->new("$_->[0]", "$_->[1]//translit")|;
        return $output
          if defined($output =
          $global{'iconvDep'}{"$_->[0] $_->[1]"}->convert($input));
    }

    # Couldn't convert - return original text
    return $input;
}

signalAddGood(
    'server event' => sub {
        # server, data, nick, address
        my $chatnet = $_[0]{'chatnet'};
        my @args = $_[1] =~ /(?:^| )(:.*|[^ ]+)/g;
        if ($args[0] eq '301') {
            # RPL_ISON - 301 You "<nick> :<away message>"
            $args[3] = convertIn($args[3]);
        } elsif ($args[0] eq '311' or $args[0] eq '314') {
            # RPL_WHOISUSER  - 311 You "<nick> <user> <host> * :<real name>"
            # RPL_WHOWASUSER - 314 You "<nick> <user> <host> * :<real name>"
            $args[6] = convertIn($args[6]);
        } elsif ($args[0] eq '322') {
            # RPL_LIST - 322 You "<channel> <# visible> :<topic>"
            $args[4] = convertIn($args[4], $chatnet, $args[2]);
        } elsif ($args[0] eq '332') {
            # RPL_TOPIC - 332 You "<channel> :<topic>"
            $args[3] = convertIn($args[3], $chatnet, $args[2]);
        } elsif ($args[0] eq '352') {
            # RPL_WHOREPLY - 352 You "<channel> <user> <host> <server> <nick>
            #                         <H|G>[*][@|+] :<hopcount> <real name>"
            my ($hops, $ircname) = split / /, $args[8], 2;
            $ircname = convertIn($ircname);
            $args[8] = "$hops $ircname";
        } elsif ($args[0] eq '371' or $args[0] eq '372') {
            # RPL_INFO - 371 You ":<string>"
            # RPL_MOTD - 372 You ":- <text>"
            $args[2] = convertIn($args[2]);
        } elsif ($args[0] eq 'KICK') {
            # KICK #channel pikkumyy :Foo
            $args[3] = convertIn($args[3], $chatnet, $args[1]);
        } elsif ($args[0] eq 'KILL') {
            # KILL David :(csd.bu.edu <- tolsun.oulu.fi)
            $args[2] = convertIn($args[2]);
        } elsif ($args[0] eq 'NOTICE') {
            # NOTICE #channel :Foobar
            $args[2] = convertIn($args[2], $chatnet, $args[1]);
        } elsif ($args[0] eq 'PART') {
            # PART #channel :Foo
            $args[2] = convertIn($args[2], $chatnet, $args[1]);
        } elsif ($args[0] eq 'PRIVMSG') {
            # PRIVMSG Wiz :Hello, are you receiving this message?
            $args[2] = convertIn($args[2], $chatnet, $args[1]);
        } elsif ($args[0] eq 'QUIT') {
            # QUIT :Gone to have lunch
            $args[1] = convertIn($args[1]);
        } elsif ($args[0] eq 'SQUIT') {
            # SQUIT cm22.eng.umd.edu :Server out of control
            $args[2] = convertIn($args[2]);
        } elsif ($args[0] eq 'TOPIC') {
            # TOPIC #test :New topic
            $args[2] = convertIn($args[2], $chatnet, $args[1]);
        } elsif ($args[0] eq 'WALLOPS') {
            # WALLOPS :Connect '*.uiuc.edu 6667' from Joshua
            $args[1] = convertIn($args[1]);
        } else {
            return;
        }
        $_[1] = "@args";
        return 1;
    }
);

foreach my $signal ('message dcc', 'message dcc action') {
    signalAddGood(
        $signal => sub {
            # dcc, msg
            $_[1] = convertIn($_[1]) and return 1;
            return;
        }
    );
}

foreach my $signal (
    'message own_public', 'message own_private',
    'message own_action', 'message dcc own',
    'message dcc own_action'
  )
{
    signalAddGood(
        $signal => sub {
            # server, msg, target, (orig_target)
            # dcc, msg
            if (defined $global{'lastOwnMsg'}) {
                $_[1] = $global{'lastOwnMsg'};
                return 1;
            }
            return;
        }
    );
}
