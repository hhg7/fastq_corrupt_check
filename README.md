# fastq_corrupt_check
Check a FASTQ file to see if it is corrupt

# Usage: 

fastq_corrupt_check can accept any number of fastq files, and will check all files mentioned after `perl fastq_corrupt_check.pl`

`perl fastq_corrupt_check.pl file1 file2`

where each file has `fastq` or `fq` at the end, with no compression, `gz` compression, or `bz2` compression.

`perl fastq_corrupt_check.pl file.fastq.bz2 file0.fq.gz file1.fastq`

# How it Works

This short program was inspired by FastQC, which did not check for file corruption.  `fastq_corrupt_check.pl` checks to ensure
that Fastq files are not corrupted.  Each entry in a Fastq file has 4 lines.  The fastq file should have the following properties:

    * The 2nd line should only consist of A, C, G, T, and/or N
    * The length of the 4th line matches the length of the 2nd line
    * The 3rd line must start with a '+'
    * The file should have an integral multiple of 4 number of lines.
    
This program is not complicated.  It is meant as a timesaver.  I am putting it here because FastQC didn't noticed that a file was corrupted in transfer.
