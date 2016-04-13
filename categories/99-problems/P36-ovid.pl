use v6;

=begin pod

=TITLE P36 - Determine the prime factors of a given positive integer (2).

=AUTHOR Curtis Poe

Hint: The problem is similar to problem P13.

This was originally a blog post:
L<http://blogs.perl.org/users/ovid/2010/08/prime-factors-in-perl-6.html>.

=head1 Specification

   P36 (**) Determine the prime factors of a given positive integer (2).
       Construct a list containing the prime factors and their multiplicity.

=head1 Example

    > prime_factors_mult(315).perl.say
    (3 => 2, 5 => 1, 7 => 1)

=end pod

constant PRIMES = grep { .is-prime }, 2 .. *;

sub prime-factors(Int $number-to-factor where * > 1 --> Hash) {
    return { $number-to-factor => 1 } if $number-to-factor.is-prime;

    my %factors;
    my $number = $number-to-factor;
    for PRIMES.cache -> $prime {
        last if $prime ** 2 > $number;
        while $number %% $prime {
            %factors{$prime}++;
            $number div= $prime;
        }
    }
    %factors{$number}++ if $number != 1;  # we have a prime left over
    return %factors;
}

for 2, 17, 53, 90, 94, 200, 289, 62710561 -> $number {
    say "Prime factors of $number are: {prime-factors($number).perl}";
}

# vim: expandtab shiftwidth=4 ft=perl6
