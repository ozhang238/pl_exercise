#!/usr/bin/perl
use strict; use warnings;

my $infile = shift;
$infile = "tb_top.sv" if !$infile;
open my $fh , "<", $infile or die "Could not open file $infile for read :$!\n";
&parse($fh);
sub parse(){
    my $fh = shift;
    my $in="";
    my $match = "";
    my $comment;
    while (!eof($fh)){
        if ( $match && $in =~ s/($match)//s ){
            print "\n" if $comment eq "//";
            $match = "";
        }
        elsif ( !$match && $in =~ s/(.*?)(\/\/|\/\*)//s){
            print $1;
            $comment = $2;
            $match = '(.*?)\n' if $comment eq "//";
            $match = '(.*?\*\/)' if $comment eq "/*";
        }
        else{
            $in .= <$fh>;
        }
    }
    print $in;
}
