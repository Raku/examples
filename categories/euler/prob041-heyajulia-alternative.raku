=begin pod

=TITLE Pandigital Prime

=AUTHOR Julia (GitHub: heyajulia)

We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once. For example,
2143 is a 4-digit pandigital and is also prime. What is the largest n-digit pandigital prime that exists?

=head1 What's interesting here?

Note: This is a cleverer (and theoretically faster) solution than prob041-heyajulia.raku.

This example showcases backwards C<Seq>s, the topic variable C<$_> and implicitly calling a method on it, blocks,
breaking out of a loop with C<last>, the fact that empty arrays are falsey, the topicalizer C<given>, and the hyper
method call operator C<».>.

=head1 More

L<https://projecteuler.net/problem=41>

=head1 Features used

=item Backwards C<Seq>s - https://docs.raku.org/routine/%2E%2E%2E
=item C<$_> and implicitly calling a method on it - https://docs.raku.org/syntax/%24_
=item Blocks - https://docs.raku.org/syntax/blocks
=item Breaking out of a loop with C<last> - https://docs.raku.org/syntax/last
=item Empty arrays are falsey
=item The topicalizer C<given> - https://docs.raku.org/syntax/given
=item Hyper method call operator C<».>. - https://docs.raku.org/language/operators#methodop_%C2%BB%2E_/_methodop_%3E%3E%2E

The answer is 7652413.

=end pod

for 9...1 {
    { say .max; last; } if $_ given permutations(1..$_)».join.grep(*.is-prime);
}
