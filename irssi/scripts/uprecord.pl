#!/usr/bin/perl

# amaroknp.pl (0.1)

# This is a simple script for irssi which (attempts to) show the current song played
# by amaroK in the current channel or query window. It should output something like
# this: <@mynick> np: Artist - Song (1:34 / 4:05). This script has been tested to work 
# with amaroK 0.9, KDE 3.2.1 and irssi 0.8.9 (on Linux). Might not work with older
# versions of amaroK.

# !! The only thing you might want to change is $dcopbin (line 45) !!
# !! and the format of $output (line 102) !!
 
# TODO
# - Cleaning up this mess :)
# - Setting options
# - Simple controls (play, pause, next, previous..)

use vars qw($VERSION %IRSSI);
use Irssi;
use strict;
$VERSION = '0.10';
%IRSSI = (
    authors	=> 'me',
    contact	=> 'nope',
    name	=> 'uptime',
    description	=> 'Sends uptime to channel',
    license	=> 'GPL',
    url		=> 'http://localhost',
    changed	=> 'Tue Aug 03 15:40 EET 2008',
);

# !! Adjust this to the full path of dcop if it's not in your PATH. eg. /opt/kde/bin/dcop !!
#my $upre = "upre";
my $upre = "/usr/local/bin/upre";

# Let's check if we have dcop..
if (!`$upre`) {
	die "Couldn't find upre executable";
}

sub cmd_uprecord {

	my ($data, $server, $witem) = @_;
	my $output;			# The format in which all this is going -> channel

	$output = `$upre`;
	$output =~ s/,//g;
	$output =~ s/ days/d/g;
	$output =~ s/ (\d\d):(\d\d)/ $1h $2m/g;
	$output =~ s/(\d\dm):(\d\d)/$1/g;

	if ($output) {
		if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
			$witem->command("MSG ".$witem->{name}." $output");
		}
		else {
			Irssi::print("This is not a channel/query window :b");
		}
	}
}
Irssi::command_bind('uprecord', 'cmd_uprecord');
