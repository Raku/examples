use v6;

=begin pod

=TITLE Read DNA sequences and write their reverse-complement

=AUTHOR Daniel Carrera

Based on the submission for Perl 5.

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=revcomp>

USAGE: perl6 revcomp.p6.pl revcomp.input

=end pod

my ($desc,$seq) = ('','');
while $*IN.get -> $line {
    if $line.match(/^ \>/) {
        print_revcomp();
        $desc = $line;
        $seq = '';
    } else {
        $seq ~= $line;
    }
}
print_revcomp();

sub print_revcomp() {
    return if not $desc;
    say $desc;
    $seq = $seq.flip.trans('wsatugcyrkmbdhvnATUGCYRKMBDHVN' => 'WSTAACGRYMKVHDBNTAACGRYMKVHDBN');

    for ^($seq.chars/60) -> $i {
        say $seq.substr($i*60,60);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
