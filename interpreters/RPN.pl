# Reverse Polish Notation Calculator.
#
# Copyright 2009 Daniel Carrera
# This is free software. You can use it under the terms of Perl itself.
#
# USAGE: perl6 RPN.pl  "5 4 + 3 / 5 3 - *"

use v6;

my token Op { '+' || '-' || '*' || '/' };
my token Value { \d+[\.\d+]? };
my token  Item { <Value> || <Op> };
my token  Expr { [<Item> <ws>]+ };

my $str = @*ARGS[0] // die "No input string specified";

if $str ~~ /^ <Expr> $/ {
	my @stack;

	for $/<Expr><Item>.list -> $item {
		if $item<Value> {
			@stack.push($item<Value>);
		} else {
			my $v1 = @stack.pop;
			my $v0 = @stack.pop;
			@stack.push(do_op($v0,$v1,$item<Op>));
		}
	}
	say @stack[0];
} else {
	say "This is not an RPN expression.";
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
