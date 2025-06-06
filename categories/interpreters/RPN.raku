use v6;

=begin pod

=TITLE Reverse Polish Notation Calculator

=AUTHOR Daniel Carrera

=head1 USAGE

    perl6 RPN.pl  "5 4 + 3 / 5 3 - *"

=end pod

my token Op { '+' || '-' || '*' || '/' };
my token Value { \d+[\.\d+]? };
my token  Item { <Value> || <Op> };
my token  Expr { [<Item> <ws>]+ };

sub MAIN(Str $expression = "5 4 + 3 / 5 3 - *") {
    calculate($expression);
}

sub calculate(Str $str) {
    if $str ~~ /^ <Expr> $/ {
        my @stack;

        for $/<Expr><Item>.list -> $item {
            if $item<Value> {
                @stack.push($item<Value>);
            }
            else {
                my $v1 = @stack.pop;
                my $v0 = @stack.pop;
                @stack.push(do_op($v0,$v1,$item<Op>));
            }
        }
        say @stack[0];
    }
    else {
        say "This is not an RPN expression.";
    }
}

sub do_op($lhs, $rhs, $op) {
    given $op {
        when '*' { $lhs * $rhs }
        when '+' { $lhs + $rhs }
        when '-' { $lhs - $rhs }
        when '/' { $lhs / $rhs }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
