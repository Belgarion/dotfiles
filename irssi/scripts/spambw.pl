#!/usr/bin/perl

use vars qw($VERSION %IRSSI);
use Irssi;
use strict;
$VERSION = '0.10';
%IRSSI = (
    authors	=> 'S',
    contact	=> 's...',
    name	=> 'bandwidth',
    description	=> 'Spams bandwidth from .rrd file to current channel',
    license	=> 'GPL',
    url		=> 'http://localhost/',
    changed	=> 'Tue Jun 02 20:00 EET 2008',
);

sub cmd_bw_help {

print "";
print "/bw [<period> <computer>]";
print "Examples: ";
print "/bw hour localhost";
print "/bw day desktop";
print "/bw week citadel";
print "";
print "/speed [computer] (default is localhost)";
print "";

}

sub fetchData {
	my($period, $computer) = @_;
	my $TIME=`date +%s`;
	
	my ($title, $file, $end, $up, $down, $rrdres);

	if ($period =~ /hour/i) {
		$title = "Hour";
		$period = "1h";
		$rrdres = 300;
	} elsif ($period =~ /day/i) {
		$title = "Day";
		$period = "1d";
		$rrdres = 300;
	} elsif ($period =~ /week/i) {
		$title = "Week";
		$period = "1w";
		$rrdres = 1800;
	} elsif ($period =~ /month/i) {
		$title = "Month";
		$period = "1mon";
		$rrdres = 7200;
	} else {
		$computer = "localhost";
		$title = "Day";
		$period = "1d";
		$rrdres = 300;
	}

	$file = "/var/lib/mrtg/$computer/net.rrd";
	if ( ! -e $file ) {
		Irssi::print("File not found ($file)");
		return;
	}
	if ($computer =~ m,^/$, || !$computer) {
		$computer = "localhost";
	}

	$end = $TIME/$rrdres*$rrdres;
	$up=0;
	$down=0;
	foreach my $i (`rrdtool fetch $file AVERAGE -r $rrdres -e $end -s e-$period | grep -v nan|tail -n +2`) {
		my ($Fld1,$Fld2,$Fld3) = split(' ', $i, -1);
		if ($Fld2) {
			$down += $Fld2*$rrdres;
		}
		if ($Fld3) {
			$up += $Fld3*$rrdres;
		}
	}
	my $upstring = "";
	my $downstring = "";
	if ($up >= 1000*1000*1000) {
		$upstring = sprintf("%.2f", $up/1000/1000/1000)."gb";
	} elsif ($up >= 1000*1000) {
		$upstring = sprintf("%.2f", $up/1000/1000)."mb";
	} else {
		$upstring = sprintf("%.2f", $up/1000)."kb";
	}

	if ($down >= 1000*1000*1000) {
		$downstring = sprintf("%.2f", $down/1000/1000/1000)."gb";
	} elsif ($down >= 1000*1000) {
		$downstring = sprintf("%.2f", $down/1000/1000)."mb";
	} else {
		$downstring = sprintf("%.2f", $down/1000)."kb";
	}

	return "$computer [1;40m$title:[1;32m Up: [0m".$upstring ."[1;34m Down: [0m".$downstring;
}

sub cmd_bw {
	my ($data, $server, $witem) = @_;
	my $output;			# The format in which all this is going -> channel

	if ($data) {
		my ($period, $computer) = split(' ', $data);
		#$output = `rrd.pl /var/lib/mrtg/$computer/net.rrd $period 2>/dev/null`;
		$output = fetchData($period, $computer);
	} else {
		#$output = `rrd.pl /var/lib/mrtg/net.rrd 2>/dev/null`;
		$output = fetchData("day", "/");
	}

	if ($output) {
		if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
			$witem->command("MSG ".$witem->{name}." $output");
		}
		else {
			Irssi::print("This is not a channel/query window :b");
		}
	}
}

sub cmd_speed {
	my ($data, $server, $witem) = @_;
	my $output;			# The format in which all this is going -> channel

	my $RRDRES = 300;
	my $TIME = `date +%s`;
	my $end = $TIME/$RRDRES*$RRDRES;

	my $file = "/var/lib/mrtg/net.rrd";

	my $title = "localhost";
	if ($data) {
		my ($computer) = split(' ', $data);
		$file = "/var/lib/mrtg/$computer/net.rrd";
		$title = $computer;
	}
	if ( ! -e $file) {
		Irssi::print("File not found ($file)");
		return;
	}
	my $speed=`rrdtool fetch $file AVERAGE -r 300 -e $end -s e-15m 2>/dev/null|grep -v nan|tail -n 1`;
	my ($t, $downspeed, $upspeed) = split(' ', $speed, -1);
	my $output = "[1;40m$title: [1;32mUp: [0;37m".sprintf("%.2f kB/s", $upspeed/1024)." [1;34mDown: [0;37m".sprintf("%.2f kB/s", $downspeed/1024);

	if ($output) {
		if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
			$witem->command("MSG ".$witem->{name}." $output");
		}
		else {
			Irssi::print("This is not a channel/query window :b");
		}
	}
}

Irssi::command_bind('bw', 'cmd_bw');
Irssi::command_bind('speed', 'cmd_speed');
Irssi::command_bind('bwhelp', 'cmd_bw_help');
