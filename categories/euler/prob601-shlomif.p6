use v6;

=begin pod

=TITLE Divisibility streaks

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=601>


=head2 Usage

=end pod

sub calc_P($s, $N)
{
    my $l = [lcm] 1 .. $s;
    my $i = $l;
    my $ret = 0;
    my $t = $s + 1;
    my $M = $N - 1;
    while $i < $M
    {
        if $i % $t
        {
            ++$ret;
        }
        $i += $l;
    }
    return $ret;
}

sub print_P($s, $N)
{
    my $ret = calc_P($s, $N);
    say "calc_P(s=$s, N=$N) = $ret";
    return $ret;
}

sub MAIN(Bool :$verbose = False)
{
    print_P(3, 14);
    print_P(6, 10**6);
    print_P(2, 4**2);
    my $mysum = 0;
    my $p = 4;
    for 1 .. 31 -> $i
    {
        $mysum += print_P($i, $p);
        say "mysum($i) = $mysum";
        $p *= 4;
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
