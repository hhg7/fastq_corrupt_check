#!/usr/bin/env perl

use strict; use warnings;
use Cwd 'getcwd';
use feature 'say';
my $TOP_DIRECTORY = getcwd();

sub log_error_and_die {
    my $error = shift;
#https://codereview.stackexchange.com/questions/182010/parallel-processing-in-different-directories-in-perl?noredirect=1#comment345753_182010
    my $fail_filename = "$TOP_DIRECTORY/$0.FAIL";
    open my $fh, '>', $fail_filename or die "Can't write $fail_filename: $!";
    print $fh $error;

    die $error;
}

local $SIG{__WARN__} = sub {
    my $message = shift;
    log_error_and_die( sprintf( '%s @ %s', $message, getcwd() ) );
};

foreach my $file (@ARGV) {
	my $compression;

	if ($file =~ m/(fq|fastq)\.?(bz2|gz)?$/) {
		$compression = $2;
	} else {
		say "$file failed regex.";
		die;
	}

	my $cat = 'cat';
	if ($compression) {#if defined
		if ($compression eq 'bz2') {
			$cat = 'bzcat';
		} elsif ($compression eq 'gz') {
			$cat = 'zcat';
		}
	}
	my $line_number = 0;
	my $no_of_nucleotides;
	foreach my $line (`$cat $file`) {
		$line_number++;
		chomp $line;
		if ($line_number == 2) {#@ the 2nd entry
			$no_of_nucleotides = length $line;
		}
		if (($line_number == 2) && ($line !~ m/^[ACGTN]+$/)) {
			say "There are some contaminating characters in line2: $line";
			die;
		}
		if (($line_number == 3) && ($line !~ m/^\+/)) {
			say "$line should start with a '+'";
			die;
		}
		if ($line_number == 4) {#@ the 4th entry
			my $length4 = length $line;
			if ($no_of_nucleotides != $length4) {
				say "$line is not $no_of_nucleotides long, rather $length4, which it should be.";
				die;
			}
			undef $no_of_nucleotides;#so entries can't talk to one another
		}
		say $line;
		if ($line_number == 4) {
			$line_number = 0;
		}
	}
	if ($line_number != 0) {
		say "There are an incorrect number of lines in $file, it should be a multiple of 4.";
		die;
	}
	say "\n$file looks good!\n";
}
