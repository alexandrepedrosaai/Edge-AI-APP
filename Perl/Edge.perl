#!/usr/bin/perl
use strict;
use warnings;

# Open the log file
my $file = 'app.log';
open(my $fh, '<', $file) or die "Could not open $file: $!";

# Hash to store counts per day
my %error_count;

# Example log format: [2026-04-16 12:34:56] ERROR Something went wrong
while (my $line = <$fh>) {
    if ($line =~ /\[(\d{4}-\d{2}-\d{2})\s+\d{2}:\d{2}:\d{2}\]\s+ERROR/) {
        my $date = $1;   # capture the date part (YYYY-MM-DD)
        $error_count{$date}++;
        print $line;     # print the error line if you want to see it
    }
}

close($fh);

# Print summary report
print "\nError summary by day:\n";
foreach my $date (sort keys %error_count) {
    print "$date : $error_count{$date} errors\n";
}
