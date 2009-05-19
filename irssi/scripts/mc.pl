# Script adds statusbar item mailcount and displays info about new mails
# in your mailbox ( not support for maildir)
#
# Run command '/statusbar window add mailcount' after loading mailcount.pl.
#
# Modules:
#
#    Mail::MboxParser 
#         http://search.cpan.org/CPAN/authors/id/V/VP/VPARSEVAL/Mail-MboxParser-0.41.tar.gz
#         http://derwan.irssi.pl/perl-modules/Mail-MboxParser-0.41.tar.gz
#
#    Digest::MD5
#         http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/Digest-MD5-2.27.tar.gz
#         http://derwan.irssi.pl/perl-modules/Digest-MD5-2.27.tar.gz
#
# Settings:
#
#    Mailcount_mailbox [ list separated with spaces ] 
#         - ex. /set mailcount_mailbox /var/mail/derwan /home/derwan/inbox
#
#    Mailcount_ofset [ sconds ]
#         - 60 by default
#
#    Mailcount_sbitem [ format ]
#         - %n - new messages
#         - %o - old messages
#         - %t - total
#

use strict;
use vars qw($VERSION %IRSSI);

use Irssi 20021117 qw( settings_add_str settings_get_str settings_add_int settings_get_int
   settings_add_bool settings_get_bool get_irssi_dir timeout_add_once theme_register active_win );

$VERSION = '1.0';
%IRSSI = (
  authors      => 'Sebastian Larsson',
  contact      => 'sebastian@home',
  name         => 'mailcount',
  description  => 'Adds statusbar item mailcount',
  modules      => 'Mail::MboxParser Digest::MD5',
  license      => 'GNU GPL v2',
  url          => 'http://localhost',
  changed      => 'Tue Aug 05 23:13:37 CEST 2008'
);

use Irssi::TextUI;
use IO::File;
use POSIX '_exit';
use Mail::MboxParser;
use Digest::MD5 'md5_hex';
use File::HomeDir;

our ($u, $r, $active_pid, $input_tag) = (0, 0, undef, undef);
our (%register, %ctime, %cache, @buf);

sub mailcount {
	return if ( $active_pid or $input_tag );
	my $reader = IO::File->new() or return;
	my $writer = IO::File->new() or return;
	my ($n, $o) = (0, 0);
	pipe($reader, $writer);
	$active_pid = fork();
	return unless ( defined $active_pid );
	if ( $active_pid ) {
		close($writer);
		Irssi::pidwait_add($active_pid);
		$input_tag = Irssi::input_add(fileno($reader), INPUT_READ, \&input_read, $reader);
	} else {
		close($reader);
		foreach my $box ( split /[: ]+/, settings_get_str('mailcount_mailbox') ) {
			my ($mo, $mn);
			$box =~ s/~/$~{''}/;
			if (-e $box) {
				my $parseropts = {
					enable_cache    => 1,
					enable_grep     => 1,
					cache_file_name => sprintf('%s/.mailcount-cache', get_irssi_dir)
				};
				my $mb = Mail::MboxParser->new($box,
					decode     => 'NONE',
					parseropts => $parseropts );
				for my $msg ($mb->get_messages) {
					my $status = $msg->header->{status};

					if ( $status =~ m/[OR]+/i ) {
						++$mo;
					} else {
						++$mn;
					}
				}
			}
			$n += $mn; $o += $mo;
		}
		push(@buf,"total n=$n o=$o");
		foreach my $data ( @buf ) { print($writer "$data\n"); }
		close($writer);
		POSIX::_exit(1);
	}
}

sub input_read {
	my $reader = shift;
	while (<$reader>) {
		chomp;
		/^total n=(\d+) o=(\d+)/ and $u = $1, $r = $2, last;
	}
	Irssi::input_remove($input_tag);
	#close($reader);
	$input_tag = $active_pid = undef;
	Irssi::statusbar_items_redraw('mailcount');
	my $timeout = settings_get_int('mailcount_ofset'); $timeout = 15 if ( $timeout <= 15 );
	timeout_add_once($timeout*1000, 'mailcount', undef);
}

sub mailcount_sbitem {
	my ($sbitem, $get_size_only) = @_;
	$sbitem->{min_size} = $sbitem->{max_size} = 0 if ($get_size_only);
	my $sbitem_format = settings_get_str('mailcount_sbitem');
	$sbitem_format = 'n/%n o/%o t/%t' unless ( $sbitem_format );
	$sbitem_format =~ s/%n/$u/e;
	$sbitem_format =~ s/%o/$r/e;
	$sbitem_format =~ s/%t/($u + $r)/e;
	$sbitem->default_handler($get_size_only, undef, $sbitem_format, 1);
}

settings_add_str('mailcount', 'mailcount_mailbox', $ENV{'MAIL'});
settings_add_int('mailcount', 'mailcount_ofset', 60);
settings_add_str('mailcount', 'mailcount_sbitem', 'n/%n o/%o t/%t');

Irssi::statusbar_item_register('mailcount', '{sb Mail: $0-}', 'mailcount_sbitem');
mailcount();
