#!/usr/bin/perl
use strict; use warnings;

my $infile = shift;

$infile = "tb_top.sv" if !$infile;
open my $fh , "<", $infile or die "Could not open file $infile for read :$!\n"; 
&parse($fh);

sub parse{
    my $fh = shift;
    while ( !eof($fh)){
        print <$fh>;#replace this code
    }
}
