=begin pod

=head1 24 game

 The 24 Game tests one's mental arithmetic.
 Write a program that randomly chooses and displays four digits, each from one to nine, with repetitions allowed. The program should prompt for the player to enter an equation using just those, and all of those four digits. The program should check then evaluate the expression. The goal is for the player to enter an expression that evaluates to 24.
 Only multiplication, division, addition, and subtraction operators/functions are allowed.
 Division should use floating point or rational arithmetic, etc, to preserve remainders.
 Brackets are allowed, if using an infix expression evaluator.
 Forming multiple digit numbers from the supplied digits is disallowed. (So an answer of 12+12 when given 1, 2, 2, and 1 is wrong).
 The order of the digits when given does not have to be preserved.
 Note:
 The type of expression evaluator used is not mandated. An RPN evaluator is equally acceptable for example.
 The task is not for the program to generate the expression, or test whether an expression is even possible.

=head1 More
 http://rosettacode.org/wiki/24_game#Perl_6

=head1 What's interesting here?

=item grammar
=item eval
=item prompt
=item roll
=item casting

=end pod

grammar Exp24 {
    token TOP { ^ <exp> $ }
    token exp { <term> [ <op> <term> ]* }
    token term { '(' <exp> ')' | \d }
    token op { '+' | '-' | '*' | '/' }
}
 
my @digits = roll 4, 1..9;  # to a gamer, that's a "4d9" roll
say "Here's your digits: {@digits}";
 
while my $exp = prompt "\n24-Exp? " {
    unless is-valid($exp, @digits) {
        say "Sorry, your expression is not valid!";
        next;
    }
 
    my $value = eval $exp;
    say "$exp = $value";
    if $value == 24 {
        say "You win!";
        last;
    }
    say "Sorry, your expression doesn't evaluate to 24!";
}
 
sub is-valid($exp, @digits) {
    unless ?Exp24.parse($exp) {
        say "Expression doesn't match rules!";
        return False;
    }
 
    unless $exp.comb(/\d/).sort.join == @digits.sort.join {
        say "Expression must contain digits {@digits} only!";
        return False;
    }
 
    return True;
}

=begin pod

=head1 Features used

=item C<type casting> - L<http://perlcabal.org/syn/S13.html#Type_Casting>

=end pod
