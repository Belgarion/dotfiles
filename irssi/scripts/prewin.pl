# Print hilighted messages & private messages to window named "hilight"
# for irssi 0.7.99 by Timo Sirainen
use strict;
use Irssi;
#use File::HomeDir;
use vars qw($VERSION %IRSSI); 
$VERSION = "0.01";
%IRSSI = (
    authors	=> 'Sebastian Larsson',
    contact	=> 'sebbe1991@gmail.com', 
    name	=> 'prewin',
    description	=> 'Print messages matched by filter to window named as the filter',
    license	=> 'Public Domain',
    url		=> 'http://irssi.org/',
    changed	=> '2007-10-04T14:34+0200',
);

#sub read_files {
#	my ($window, $file);
#	$file = File::HomeDir->my_home()."/irclogs/pre/";
#	$window = Irssi::window_find_name('DVDR');
#	open (INP, "<$file/DVDR");
#	my @DVDR = <INP>;
#	close(INP);
#	foreach my $LINE (@DVDR) {
#		$window->print($LINE, MSGLEVEL_NEVER) if ($window);
#	}
#}

sub sig_add {
	my ($dest, $text, $stripped) = @_;
	my ($window, $match);

	my @matches = ("DVDR", "TV", "GAMES");

	foreach $match (@matches)
	{
		if (($text =~ /::.*PRE.*::.*::\[.*$match.*\]::.*::\./) && ($dest->{level} & MSGLEVEL_PUBLIC)) {
			$text =~ s/.*>.....//;
			$window = Irssi::window_find_name("$match");
			#Irssi::print("Create a window named '$match'") if (!$window);
			if (!$window) {
				Irssi::command("window new hidden");
				Irssi::command("window name $match");
			}
			$window->print($text, MSGLEVEL_CLIENTCRAP) if ($window); 
		}
	}
}

Irssi::signal_add('print text', 'sig_add');
# Irssi::command_bind loadpre => \&read_files;
