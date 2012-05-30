# The Computer Language Benchmarks Game
#
# Based on the submission for Perl 5.
# contributed by Daniel carrera
#
# USAGE: perl6 regex-dna.p6.pl < regex-dna.input

my $content = $*IN.slurp;
my $len_file = $content.chars;

$content .= subst(/ (^^ \> \N*)? \n/, '', :global);
$content = lc $content;
my $len_code = $content.chars;

my @seq = ( 'agggtaaa|tttaccct',
        '[cgt]gggtaaa|tttaccc[acg]',
        'a[act]ggtaaa|tttacc[agt]t',
        'ag[act]gtaaa|tttac[agt]ct',
        'agg[act]taaa|ttta[agt]cct',
        'aggg[acg]aaa|ttt[cgt]ccct',
        'agggt[cgt]aa|tt[acg]accct',
        'agggta[cgt]a|t[acg]taccct',
        'agggtaa[cgt]|[acg]ttaccct' );
my @regex = ( /agggtaaa|tttaccct/,
        /<[cgt]>gggtaaa|tttaccc<[acg]>/,
        /a<[act]>ggtaaa|tttacc<[agt]>t/,
        /ag<[act]>gtaaa|tttac<[agt]>ct/,
        /agg<[act]>taaa|ttta<[agt]>cct/,
        /aggg<[acg]>aaa|ttt<[cgt]>ccct/,
        /agggt<[cgt]>aa|tt<[acg]>accct/,
        /agggta<[cgt]>a|t<[acg]>taccct/,
        /agggtaa<[cgt]>|<[acg]>ttaccct/ );

my @cnt = (0) xx @seq;
for @seq.keys -> $k {
	for $content.comb(@regex[$k]) { @cnt[$k]++ }
	say @seq[$k] ~ " " ~ @cnt[$k];
}

my %iub = 	'b' => '(c|g|t)',	'd' => '(a|g|t)',	'h' => '(a|c|t)',
			'k' => '(g|t)',		'm' => '(a|c)',		'n' => '(a|c|g|t)',
			'r' => '(a|g)',		's' => '(c|g)',		'v' => '(a|c|g)',
			'w' => '(a|t)',		'y' => '(c|t)';

$content .= subst(/(<[bdhkmnrsvwy]>)/, -> $/ { %iub{$0} }, :global);

say "\n$len_file\n$len_code\n" ~ $content.chars;

