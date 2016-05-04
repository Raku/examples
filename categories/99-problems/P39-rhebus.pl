use v6;

=begin pod

=TITLE P39 - A list of prime numbers.

=AUTHOR Curtis "Ovid" Poe

=head1 Specification

    P39 (*) A list of prime numbers.
      Given a range of integers by its lower and upper limit, construct a list
      of all prime numbers in that range.

=head1 Example

    > say ~ grep { .is-prime }, 10..19;
    11 13 17 19

=end pod

# we can call it with a range, as in the specification...
say ~ grep { .is-prime }, 10..20;

# or we can pass a list...
say ~ grep { .is-prime }, 3,5,17,257,65537;
# or another range
say ~ grep { .is-prime }, 1..100;

# vim: expandtab shiftwidth=4 ft=perl6
