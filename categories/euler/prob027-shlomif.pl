use v6;

sub is_prime(Int $n) returns Bool {
    if ($n <= 1) {
        return False;
    }

    for (2 .. $n.sqrt.floor) -> $i {
        if $n % $i == 0 {
            return False;
        }
    }

    return True;
}

my (Int $max_a, Int $max_b);

my Int $max_iter = 0;
for (0 .. 999) -> $b_coeff {
    for ((-$b_coeff+1) .. 999) -> $a_coeff {
        my $n = 0;
        while is_prime($b_coeff+$n*($n+$a_coeff)) {
            $n++;
        }
        $n--;

        if ($n > $max_iter) {
            ($max_a, $max_b, $max_iter) = ($a_coeff, $b_coeff, $n);
        }
    }
}
say "a = $max_a ; b = $max_b ; a*b = {$max_a*$max_b} ; n = $max_iter\n"

# vim: expandtab shiftwidth=4 ft=perl6
