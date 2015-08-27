use v6;

=begin pod

=TITLE Largest exponential

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=99>

Comparing two numbers written in index form like 2^11 and 3^7 is not
difficult, as any calculator would confirm that 2^11 = 2048 < 3^7 = 2187.

However, confirming that 632382^518061 > 519432^525806 would be much more
difficult, as both numbers contain over three million digits.

Using base_exp.txt
L<https://projecteuler.net/project/resources/p099_base_exp.txt>, a 22K text
file containing one thousand lines with a base/exponent pair on each line,
determine which line number has the greatest numerical value.

NOTE: The first two lines in the file represent the numbers in the example
given above.

=end pod

class BaseExp {
    has $.base;
    has $.exp;
    has $.line;
    method comparable {
        $.exp * $.base.log;
    }
}

multi infix:«cmp»(BaseExp $a, BaseExp $b) {
    $a.comparable <=> $b.comparable;
}

multi my-max($a, $b where $a cmp $b ~~ More) { $a }
multi my-max($a, $b) { $b }

sub MAIN(:$file  = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'base_exp.txt'),
        ) {
    die "'$file' is missing" unless $file.IO.e ;
    my $n = 1 ;
    say .line for [[&my-max]] do for $file.IO.lines -> $l {
        my ($base, $exp) = $l.split: /','/;
        BaseExp.new(base => $base,
                    exp  => $exp,
                    line => $n++);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
