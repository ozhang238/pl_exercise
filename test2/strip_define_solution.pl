#!/usr/bin/perl
use strict; use warnings;

my $infile = shift;

$infile = "tb_top.sv" if !$infile;
open my $fh , "<", $infile or die "Could not open file $infile for read :$!\n"; 
&parse($fh);

sub parse{
    my $fh = shift;
    my $in = "";
    my @curr;
    my %defined;
    my $macro_syntax = "[a-zA-Z_0-9]+";
    my $lineno;

    push @curr, {
        name => "default",
        def => 1,
        can_invert => 0,
        endif_okay => 0,
        else_okay => 0,
    };
    while ( !eof($fh)){
        if ($in =~ /(.*?)(`define|`ifndef|`ifdef|`else|`endif)/s){
            my $key = $2;
            if ($curr[$#curr]->{def} ){
                print $1
            }
            $in = substr $in, $+[2];
            if ( $key eq "`define"){
                $in =~ s/\s+\b($macro_syntax)\b//;
                if ( $curr[$#curr]->{def}){
                    $defined{$1} = 1;
                }
            }
            elsif ($key eq "`ifdef"){
                $in =~ s/\s+\b($macro_syntax)\b//;
                push @curr, {
                    name => $1,
                    def => ($curr[$#curr]->{def} ? $defined{$1} : 0 ),
                    can_invert => $curr[$#curr]->{def}, #if currently we are not okay, this subsequent ifdef's else should not take effect
                    endif_okay => 1,
                    else_okay => 1,
                };
            }
            elsif ($key eq "`ifndef"){
                $in =~ s/\s+\b($macro_syntax)\b//;
                push @curr, {
                    name => $1,
                    def => ($curr[$#curr]->{def} ? !$defined{$1} : 0 ),
                    can_invert => $curr[$#curr]->{def}, #if currently we are not okay, this subsequent ifdef's else should not take effect
                    endif_okay => 1,
                    else_okay => 1,
                };
            }
            elsif ($key eq "`else"){
                if ( $curr[$#curr]->{can_invert} ){
                    $curr[$#curr]->{def} = !$curr[$#curr]->{def};
                }
                if ( !$curr[$#curr]->{else_okay}){
                    die "Unexpected `else for define $curr[$#curr]->{name} at line $lineno\n";
                }
                $curr[$#curr]->{else_okay} = 0;
            }
            elsif ($key eq "`endif"){
                if ( !$curr[$#curr]->{endif_okay}){
                    die "Unexpected `endif for define $curr[$#curr]->{name}at line $lineno\n";
                    $curr[$#curr]->{endif_okay} = 0;
                }
                pop @curr;
            }
        }
        else{
            $in .= <$fh>;
            $lineno++;
        }
    }
    print $in;
}
