use v6;

=begin pod

=TITLE P34 - Calculate Euler's totient function phi(m).

=AUTHOR Philip Potter

Find out what the value of phi(m) is if m is a prime number. Euler's totient
function plays an important role in one of the most widely used public key
cryptography methods (RSA). In this exercise you should use the most
primitive method to calculate this function (there are smarter ways that we
shall discuss later).

=head1 Specification

    P34 (**) Calculate Euler's totient function phi(m).
          Euler's so-called totient function phi(m) is defined as the number of
          positive integers r (1 <= r < m) that are coprime to m.

=head1 Example

    # m = 10: r = 1,3,7,9; thus phi(m) = 4. Note the special case: phi(1) = 1.
    > say totient_phi 10
    4

=end pod

# from P32-rhebus.pl
sub gcds (Int $a, Int $b) {
    return ($a, $b, *%* ... 0)[*-2];
}

# from P33-rhebus.pl
our sub infix:<coprime> (Int $a, Int $b) { (gcds($a,$b) == 1).Numeric }


# Example 1: iteration
multi totient_phi_i (1      --> Int) { 1 }
multi totient_phi_i (Int $n --> Int) {
    my $total = 0;
    for 1..^$n -> $k { $total++ if $n coprime $k }
    return $total;
}

say "phi($_): ", totient_phi_i $_ for (1..20);

# Example 2: «coprime« hyper operator
multi totient_phi (1      --> Int) { 1 }
multi totient_phi (Int $n --> Int) {
    return 1 if $n ~~ 1;
    return [+] ($n «coprime« list(1..^$n));
}

say "phi($_): ",totient_phi $_ for (1..20);

# vim: expandtab shiftwidth=4 ft=perl6
