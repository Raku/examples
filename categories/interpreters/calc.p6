use v6;

=begin pod

=TITLE Simple Infix Arithmetic Calculator

=AUTHOR Yichun Zhang

Operators supported: +, -, *, /, and ^.

Usage:

=begin code

    ./calc.p6 '(3-(2-1))*8^2/4'

    ./calc.p6 < expression.txt

=end code

For benchmark results as compared to equivalent calculators
implemented atop Perl 5's Parse::RecDescent and
Regexp::Grammars, please check out the following page for details:

L<https://gist.github.com/agentzh/c5108a959309f015c4f6>

FIXME: error reporting on invalid inputs still needs love.

Contributed by Yichun Zhang, inspired by the calc demo in bison's user manual.

=end pod

my grammar Arith {
    rule TOP {
        | <.ws> <expr> { make $<expr>.made }
        | { self.panic("Bad expression") }
    }

    rule expr {
        | <term> + % <add-op>   { self.do_calc($/, $<term>, $<add-op>) }
        | { self.panic("Bad expression") }
    }

    token add-op {
        | < + - >
    }

    rule term {
        | <factor> + % <mul-op>  { make self.do_calc($/, $<factor>, $<mul-op>) }
        | { self.panic($/, "Bad term") }
    }

    token mul-op {
        | < * / >
    }

    rule factor {
        | <atom> + % '^'
            {
                make [**] map { $_.made }, @<atom>;
            }
        | { self.panic($/, "Bad factor") }
    }

    rule atom {
        | <number> { make +$<number> }
        | '(' ~ ')' <expr> { make $<expr>.made }
        | { self.panic($/, "Bad atom") }
    }

    rule number {
        <.sign> ? <.pos-num>
        | { self.panic($/, "Bad number") }
    }

    token sign { < + - > }
    token pos-num {
        | <.digit>+ [ \. <digit>+ ]?
        | \. <.digit>+
        | { self.panic($/, "Bad number") }
    }

    method do_calc($/, $operands, $operators) {
        my $res = $operands[0].made;
        my $n = $operands.elems;
        loop (my $i = 1; $i < $n; $i++) {
            my $op = $operators[$i - 1];
            my $num = $operands[$i].made;

            given $op {
                when '+' { $res += $num; }
                when '-' { $res -= $num; }
                when '*' { $res *= $num; }
                default {  # when '/'
                    $res /= $num;
                }
            }
        }
        make $res;
    }

    method panic($/, $msg) {
        my $c = $/.CURSOR;
        my $pos := $c.pos;
        die "$msg found at pos $pos";
    }
}

sub MAIN($input = (@*ARGS[0] // slurp)) {
    try Arith.parse($input);
    if $! {
        say "Parse failed: ", $!.message;

    }
    elsif $/ {
        say $();

    }
    else {
        say "Parse failed.";
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
