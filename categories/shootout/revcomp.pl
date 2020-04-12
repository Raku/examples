#!/usr/bin/perl

# The Great Computer Language Shootout
# http://shootout.alioth.debian.org/
#
# Contributed by Bradford Powell
# Fixed slow print substr-solution, by Kjetil Skotheim


use strict;

sub print_revcomp {
    my ($desc, $s) = @_;
    return if not $desc;
    print $desc, "\n";
    $s =  reverse $s;
    $s =~ tr{wsatugcyrkmbdhvnATUGCYRKMBDHVN}
            {WSTAACGRYMKVHDBNTAACGRYMKVHDBN};
    my($i,$stop)=(0,length($s)/60);
    print substr($s,$i++*60,60),"\n"  while $i<$stop;
}

my($desc,$seq);
while (<STDIN>) {
    chomp;
    if (/^>/) {
        print_revcomp($desc, $seq);
        $desc = $_;
        $seq = '';
    } else {
        $seq .= $_;
    }
}
print_revcomp($desc, $seq);

