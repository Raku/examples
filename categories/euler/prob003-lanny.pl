use v6;

=begin pod

=TITLE Largest prime factor

=AUTHOR Lanny Ripple

L<https://projecteuler.net/problem=3>

The prime factors of 13195 are 5, 7, 13 and 29.

What is the largest prime factor of the number 600851475143 ?

=end pod

class PrimeSieve {
    has Int $.p;
    has Int $.value is rw = $!p * $!p;

    method next {
        return $.value += $.p;
    }
}

class Primes {
    has Int @!primes = 2,3;

    has PrimeSieve @!wheel;
    has Int $!spix = 1;
    has Int $!spval = @!primes[$!spix] ** 2;

    method !next {
        # Candidate for next prime.
        my $z = @!primes[*-1] + 2;
        self!adjust_wheel($z);

        # Work through each stream.
        my $ix = 0;
        while $ix < @!wheel {
            my $s = @!wheel[$ix];

            # Step the current PrimeSieve if less than candidate
            $s.next if $s.value < $z;

            if $z == $s.value {
                # If the stream matches incr accumulator.
                $z += 2;
                self!adjust_wheel($z);
                $ix = 0;
            }
            else {
                # If the stream is greater then try next stream.
                ++$ix;
            }
        }

        # All streams are used up.  We are the next prime.
        @!primes.push($z);
    }

    method !adjust_wheel(Int $x) {
        if ( $x == $!spval ) {
            @!wheel.push(PrimeSieve.new(:p(@!primes[$!spix])));
            $!spix += 1;
            $!spval = @!primes[$!spix] ** 2;
        }
    }

    # postcircumfix:<[ ]> giving problems
    method ix(Int $ix) {
        self!next while $ix > @!primes.end;
        return @!primes[$ix];
    }

    method factor(Int $n is copy) {
        my Int @value;
        my Int $psqr = 4;

        loop ( my Int $ix = 0; $psqr <= $n; ++$ix ) {
            my $p = $.ix($ix);
            $psqr = $p * $p;

            while $n != 1 && $n % $p == 0 {
                @value.push($p);
                $n = ($n / $p).Int;
            }
        }

        @value.push($n) if $n != 1;

        return @value;
    }

    method is_prime(Int $n) of Bool {
        return ?0 if ( $n < 2 );

        my Int $psqr = 4;

        loop ( my Int $ix = 0; $psqr <= $n; ++$ix ) {
            my $p = $.ix($ix);
            $psqr = $p * $p;

            return ?0
            if $n % $p == 0;
        }

        return ?1;
    }

    method Str { return "{$!spix-1}: {@!primes}"; }
}

sub MAIN($n?) {
    my Primes $p .= new;

    if $n.defined {
        say "$n: {$p.factor($n.Int)}";
    }
    else {
        say $p.factor( 600_851_475_143 ).[*-1];
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
