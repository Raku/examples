# Reverse Polish Notation Calculator.
#
# Copyright 2009 Daniel Carrera
# This is free software. You can use it under the terms of Perl itself.
#
# USAGE: perl6 RPN.pl  "5 4 + 3 / 5 3 - *"

token Op { '+' || '-' || '*' || '/' };
token Value { \d+[\.\d+]? };
token  Item { <Value> || <Op> };
token  Expr { [<Item> <ws>]+ };

my $str = @*ARGS[0];

if $str ~~ /^ <Expr> $/ {
	my @stack;
	
	for $/<Expr><Item> -> $item {
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
