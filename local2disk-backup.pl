#!/usr/bin/perl

use strict;
use warnings;

my $backupdir = $ARGV[0];

opendir my($dh), $backupdir or die "Could not open $backupdir";
my @dirlist = readdir $dh;
closedir $dh;

my $day   = 0;
my $month = 0;
my $year  = 0;
foreach (@dirlist) {
	my $currdir = $_;
	if ($currdir =~ /backup.([0-9]+).([0-9]+).([0-9]+)/) {
		print $currdir."\n";
		my $curryear  = $1;
		my $currmonth = $2;
		my $currday   = $3;
		if ($curryear > $year
			or ($curryear == $year and $currmonth > $month)
			or ($curryear == $year and $currmonth == $month and $currday > $day)) {
			$year  = $curryear;
			$month = $currmonth;
			$day   = $currday;
		}
	}
}

my ($thissec,$thismin,$thishour,$thisday,$thismonth,$thisyear,@rest) =   localtime(time);

$thisday   = ($thisday <= 9 ? "0" :  "") . $thisday;
$thismonth = ($thismonth <= 8 ? "0" : "") . $thismonth + 1;
$thisyear  = $thisyear + 1900;

my $newbackup = "$backupdir/backup.$thisyear.$thismonth.$thisyear/";
system "sudo mkdir -p $newbackup";
system "sudo rsync -av --delete --progress --link-dest=$backupdir/backup.$year.$month.$day ~/ $newbackup";
