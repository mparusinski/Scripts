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
	if ($currdir =~ /backup.([0-9]{2}).([0-9]{2}).([0-9]{4})/) {
		print $currdir."\n";
		my $currday   = $1;
		my $currmonth = $2;
		my $curryear  = $3;
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

my $newbackup = "$backupdir/backup.$thisday.$thismonth.$thisyear/";
system "sudo mkdir -p $newbackup";
system "sudo rsync -av --delete --link-dest=$backupdir/backup.$day.$month.$year ~/ $newbackup";

