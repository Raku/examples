use v6;

=begin pod

=TITLE Match DNA 8-mers and substitute nucleotides for IUB code

=AUTHOR Daniel Carrera

Based on the submission for Perl 5.

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=regexdna>

USAGE: perl6 regex-dna.p6.pl regex-dna.input

=end pod

my $input = slurp;
my $data = $input.lines.grep({ $_ !~~ /^ \>/}).join.lc;

say $_ ~ ' ' ~ +$data.comb($_) for
    /agggtaaa|tttaccct/             but 'agggtaaa|tttaccct',
    /<[cgt]>gggtaaa|tttaccc<[acg]>/ but '[cgt]gggtaaa|tttaccc[acg]',
    /a<[act]>ggtaaa|tttacc<[agt]>t/ but 'a[act]ggtaaa|tttacc[agt]t',
    /ag<[act]>gtaaa|tttac<[agt]>ct/ but 'ag[act]gtaaa|tttac[agt]ct',
    /agg<[act]>taaa|ttta<[agt]>cct/ but 'agg[act]taaa|ttta[agt]cct',
    /aggg<[acg]>aaa|ttt<[cgt]>ccct/ but 'aggg[acg]aaa|ttt[cgt]ccct',
    /agggt<[cgt]>aa|tt<[acg]>accct/ but 'agggt[cgt]aa|tt[acg]accct',
    /agggta<[cgt]>a|t<[acg]>taccct/ but 'agggta[cgt]a|t[acg]taccct',
    /agggtaa<[cgt]>|<[acg]>ttaccct/ but 'agggtaa[cgt]|[acg]ttaccct';

.say;

my %iub = 'b' => '(c|g|t)', 'd' => '(a|g|t)', 'h' => '(a|c|t)',
          'k' => '(g|t)',   'm' => '(a|c)',   'n' => '(a|c|g|t)',
          'r' => '(a|g)',   's' => '(c|g)',   'v' => '(a|c|g)',
          'w' => '(a|t)',   'y' => '(c|t)';

my $output = $data.subst(/(<[bdhkmnrsvwy]>)/, { %iub{$_} }, :g);

.chars.say for $input, $data, $output;

# vim: expandtab shiftwidth=4 ft=perl6
