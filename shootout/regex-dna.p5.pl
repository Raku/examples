# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
# contributed by Danny Sauer
# completely rewritten and
# cleaned up for speed and fun by Mirco Wahab
# improved STDIN read, regex clean up by Jake Berner

use strict;
use warnings;

my $l_file  = -s STDIN;
my $content; read STDIN, $content, $l_file;
# this is significantly faster than using <> in this case

my $dispose =  qr/(^>.*)?\n/m; # slight performance gain here
   $content =~ s/$dispose//g;
my $l_code  =  length $content;

my @seq = ( 'agggtaaa|tttaccct',
        '[cgt]gggtaaa|tttaccc[acg]',
        'a[act]ggtaaa|tttacc[agt]t',
        'ag[act]gtaaa|tttac[agt]ct',
        'agg[act]taaa|ttta[agt]cct',
        'aggg[acg]aaa|ttt[cgt]ccct',
        'agggt[cgt]aa|tt[acg]accct',
        'agggta[cgt]a|t[acg]taccct',
        'agggtaa[cgt]|[acg]ttaccct' );

my @cnt = (0) x @seq;
for my $k (0..$#seq) {
  ++$cnt[$k] while $content=~/$seq[$k]/gi;
  printf "$seq[$k] $cnt[$k]\n"
}

my %iub = (         B => '(c|g|t)',  D => '(a|g|t)',
  H => '(a|c|t)',   K => '(g|t)',    M => '(a|c)',
  N => '(a|c|g|t)', R => '(a|g)',    S => '(c|g)',
  V => '(a|c|g)',   W => '(a|t)',    Y => '(c|t)' );

# using $& and no submatch marginally improves the
# speed here, but mentioning $& causes perl to
# define that value for the @seq patterns too, which
# slows those down considerably. No change.

my $findiub = '(['.(join '', keys %iub).'])';

$content =~ s/$findiub/$iub{$1}/g;

printf "\n%d\n%d\n%d\n", $l_file, $l_code, length $content;

