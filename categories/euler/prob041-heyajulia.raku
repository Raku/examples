=begin pod

=TITLE Pandigital Prime

=AUTHOR Julia (GitHub: heyajulia)

We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once. For example,
2143 is a 4-digit pandigital and is also prime. What is the largest n-digit pandigital prime that exists?

=head1 What's interesting here?

This example showcases Raku's support for functional programming, handy built-in functions like C<permutations>,
effortless parallelism with C<race>, and how flexible Raku is when it comes to type conversion. Notic how we join each
permutation into a string and check if it's prime without having to convert it to a number ourselves.

=head1 More

L<https://projecteuler.net/problem=41>

=head1 Features used

=item Ranges - L<https://docs.raku.org/type/Range>
=item C<permutations> - L<https://docs.raku.org/routine/permutations>
=item C<Slip> - L<https://docs.raku.org/type/Slip>
=item C<race> - L<https://docs.raku.org/routine/race>
=item Terse syntax for a hash with numeric values: C<(:16degree, :2048batch) == {degree => 16, batch => 2048}>
=item C<grep> - L<https://docs.raku.org/routine/grep>
=item C<say> - L<https://docs.raku.org/routine/say>

The answer is 7652413.

=end pod

(2..9)
    .map({ permutations(1..$^end).Slip })
    .race(:16degree, :2048batch)
    .map(*.join)
    .grep(*.is-prime)
    .max
    .say;
