# Print hilighted messages & private messages to window named "hilight"
# for irssi 0.7.99 by Timo Sirainen
use strict;
use Irssi;
use vars qw($VERSION %IRSSI); 
$VERSION = "0.01";
%IRSSI = (
    authors	=> "Timo \'cras\' Sirainen",
    contact	=> "tss\@iki.fi", 
    name	=> "hilightwin",
    description	=> "Print hilighted messages & private messages to window named \"hilight\"",
    license	=> "Public Domain",
    url		=> "http://irssi.org/",
    changed	=> "2002-03-04T22:47+0100"
);

sub getTime {
	my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
	my @weekDays = qw(Sun Mon Tue Wed Thu Fri Sat Sun);
	my ($sec, $min, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, 
		$dayOfYear, $daylightSavings) = localtime();
	my $year = 1900 + $yearOffset;
	$month++;
	$sec = "0$sec" if ($sec <= 9);
	$min = "0$min" if ($min <= 9);
	$hour = "0$hour" if ($hour <= 9);
	$dayOfMonth = "0$dayOfMonth" if ($dayOfMonth <= 9);
	$month = "0$month" if ($month <= 9);
	my $time = "$year-$month-$dayOfMonth $hour:$min:$sec";
	return $time;
}

sub sig_printtext {
	my ($dest, $text, $stripped) = @_;
	my $window = Irssi::window_find_name('hilight');

	if (($dest->{level} & (MSGLEVEL_HILIGHT|MSGLEVEL_MSGS)) &&
		($dest->{level} & MSGLEVEL_NOHILIGHT) == 0) {
		if ($dest->{level} & MSGLEVEL_PUBLIC) {
			$window = Irssi::window_find_name('hilight');
			$window->print("%W%0: " . $dest->{target} . ": " . $text, MSGLEVEL_PUBLIC) if ($window);
		}
	}
}

my $window = Irssi::window_find_name('hilight');
Irssi::print("Create a window named 'hilight'") if (!$window);

Irssi::signal_add('print text', 'sig_printtext');
