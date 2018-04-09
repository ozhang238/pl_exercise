#!/usr/bin/perl
use strict; use warnings;
#Open file
my $infile = shift;
$infile = "tb_top.sv" if !$infile;
open my $fh , "<", $infile or die "Could not open file $infile for read :$!\n";

#parsing
while (!eof($fh)){
    print <$fh>;
}
