use v6;

sub take-two($n) { $n*($n-1)/2 }
given $*IN.get.split: " " {
    say
    take-two([+] .[]) R/ (
	[+]
	take-two(.[0])       ,   # two homozygous dominant
	3/4 * take-two(.[1]) ,   # two heterozygous
	.[0] * .[1]          ,   # one homozygous dominant and one heterozygous
	.[0] * .[2]          ,   # one homozygous dominant and one homozygous recessive
	1/2 * .[1] * .[2]    ,   # one heterozygous and one homozygous recessive
    )
}
# vim: ft=perl6
