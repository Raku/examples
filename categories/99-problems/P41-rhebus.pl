use v6;

=begin pod

=TITLE P41 - A list of Goldbach compositions.

=AUTHOR Philip Potter

=head1 Specification

    P41 (**) A list of Goldbach compositions.
      Given a range of integers by its lower and upper limit, print a list of
       all even numbers and their Goldbach composition.

=head1 Examples

    > goldbach-list 9,20
    10 = 3 + 7
    12 = 5 + 7
    14 = 3 + 11
    16 = 3 + 13
    18 = 5 + 13
    20 = 3 + 17

In most cases, if an even number is written as the sum of two prime numbers,
one of them is very small. Very rarely, the primes are both bigger than say
50. Try to find out how many such cases there are in the range 2..3000.

Example (for a print limit of 50):

    > goldbach-list 1,2000,50
    992 = 73 + 919
    1382 = 61 + 1321
    1856 = 67 + 1789
    1928 = 61 + 1867

=end pod

# From P31-rhebus.pl again
sub is_prime (Int $n) {
    for 2..sqrt $n -> $k {
        return Bool::False if $n %% $k;
    }
    return Bool::True;
}

# require even arguments
sub goldbach (Int $n where {$^a > 2 && $^a %% 2}) {
    for 2..$n/2 -> $k {
        if is_prime($k) && is_prime($n-$k) {
            return ($k, $n-$k);
        }
    }
    # actually, it's more likely a logic error than a refutation :)
    die "Goldbach's conjecture is false! $n cannot be separated into two primes!"
}

# Here we demonstrate an optional parameter with a default value
sub goldbach-list (Int $low, Int $high, Int $limit = 1) {
    for $low .. $high -> $n {
        next if $n % 2; # skip invalid goldbach numbers
        next if $n == 2;
        my @pair = goldbach($n);
        say "$n = ", @pair.join(' + ') if @pair[0] > $limit;
    }
}

goldbach-list 9,20;
goldbach-list 2,1000,10;

# vim: expandtab shiftwidth=4 ft=perl6
