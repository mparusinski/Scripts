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

my $newbackupdir = "$backupdir/backup.$thisyear.$thismonth.$thisday/";
my $oldbackupdir = "$backupdir/backup.$year.$month.$day/";
print "Found backup directory $oldbackupdir\n";
print "Writing to new backup directory $newbackupdir\n";
system "sudo mkdir -p \"$newbackupdir\"";
system "sudo rsync -av --exclude-from 'exclude-list.txt' --delete --progress --link-dest=\"$oldbackupdir\" ~/ \"$newbackupdir\""
