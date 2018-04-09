#!/usr/bin/perl
use strict; use warnings;
#Open file
my $infile = shift;
$infile = "tb_top.sv" if !$infile;
open my $fh , "<", $infile or die "Could not open file $infile for read :$!\n";

#parsing
my $curr_string="";
my $match_comment = "";
my $key = "";
my @curr;
my %defined;
my $macro_syntax = "[a-zA-Z_0-9]+";
my $macro;
my $lineno;
push @curr, {
    name => "default",
    def => 1,
    can_invert => 0,
    next_dir => "",
};
my %get_macro = ("`define"=>1,"`undef"=>1,"`ifdef"=>1,"`ifndef"=>1);

while (!eof($fh)){
    if ( $match_comment && $curr_string =~ s/($match_comment)//s ){
        print "\n" if $key eq "//";
        $match_comment = "";
    }
   elsif (!$match_comment && $curr_string =~ /(.*?)(\/\*|\/\/|`define|`undef|`ifndef|`ifdef|`else|`endif)/s){
        $key = $2;
        if ($curr[$#curr]->{def} ){#macro valid
            print $1;
        }
        $curr_string = substr $curr_string, $+[2];
        $curr_string =~ s/\s+\b($macro_syntax)\b// if $get_macro{$key};
        $macro = $1;

        if      ( $key eq "//" ) { $match_comment = '(.*?)\n';  }
        elsif   ( $key eq "/*" ) { $match_comment = '(.*?\*\/)';}
        elsif ( $key eq "`define" and $curr[$#curr]->{def}) { $defined{$macro} = 1 }
        elsif ( $key eq "`undef"  and $curr[$#curr]->{def}) { $defined{$macro} = 0 }
        elsif ( $key eq "`ifdef"){
            push @curr, {
                name => $macro,
                def => ($curr[$#curr]->{def} ? $defined{$macro} : 0 ),
                can_invert => $curr[$#curr]->{def}, #if currently we are not okay, this subsequent ifdef's else should not take effect
                next_dir => "else",
            };
        }
        elsif ($key eq "`ifndef"){
            push @curr, {
                name => $macro,
                def => ($curr[$#curr]->{def} ? !$defined{$macro} : 0 ),
                can_invert => $curr[$#curr]->{def}, #if currently we are not okay, this subsequent ifdef's else should not take effect
                next_dir => "else",
            };
        }
        elsif ($key eq "`else"){
            $curr[$#curr]->{def} = !$curr[$#curr]->{def} if $curr[$#curr]->{can_invert};
            if ( $curr[$#curr]->{next_dir} ne "else"){
                die "Unexpected `else for define $curr[$#curr]->{name} at line $lineno\n";
            }
            $curr[$#curr]->{next_dir} = "endif";
        }
        elsif ($key eq "`endif"){
            if ( $curr[$#curr]->{next_dir} eq ""){
                die "Unexpected `endif for define $curr[$#curr]->{name}at line $lineno\n";
            }
            pop @curr;
        }
    }
    else{
        $curr_string .= <$fh>;
        $lineno++;
    }
}
print $curr_string;
