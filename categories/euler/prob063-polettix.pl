use v6;

=begin pod

=TITLE Powerful digit counts

=AUTHOR polettix

L<https://projecteuler.net/problem=63>

The 5-digit number, 16807=7^5, is also a fifth power. Similarly, the 9-digit
number, 134217728=8^9, is a ninth power.

How many n-digit positive integers exist which are also an nth power?

=end pod

# As of August 24th, 2009 we don't have big integers, so we'll have
# to conjure up something. We'll represent each number with an
# array of digits, base 10-exp for ease of length computation. The most
# significant part is at the end of the array, i.e. the array should
# be read in reverse.
# Setting '1' for the number of digits means representing the base-10
# system with one digit in each array position.
my $digits = 5;
my $limit = 10 ** $digits;

my $count = 0;

# 9 is the maximum possible base for this problem. 9**22 has 21 digits
sub MAIN(Bool :$verbose = False) {
    for 1 .. 9 -> $x {
        my @x = (1);
        for 1 .. * -> $y {
            @x = multby(@x, $x);
            my $px = printable(@x);
            if ($px.encode('utf-8').bytes == $y) {
                say "$x ** $y = $px (", $px.encode('utf-8').bytes, ')'
                    if $verbose;
                $count++;
            }
            elsif ($px.encode('utf-8').bytes < $y) {
                last;
            }
        }
    }
    say $count;
}

sub printable (@x is copy) {
    my $msb = pop @x;
    return $msb ~ @x.reverse.map({sprintf '%0'~$digits~'d', $_ }).join('');
}

# Add a "number" to another, modifies first parameter in place.
# This assumes that length(@y) <= length(@x), which will be true in
# our program because @y is lower than @x
sub add (@x is copy, @y) {
    my $rest = 0;
    return add(@y, @x) if +@x < +@y;
    for @x Z (@y, 0, *) -> $x is rw, $y {
        $x += $y + $rest;
        $rest = int($x / $limit);
        $x %= $limit;
    }
    push @x, $rest if $rest;
    return @x;
}

sub multby (@x is copy, $y) {
    my $rest = 0;
    for @x -> $x is rw {
        $x = $x * $y + $rest;
        $rest = $x div $limit;
        $x %= $limit;
    }
    push @x, $rest if $rest;
    return @x;
}

# Not really needed...
sub mult (@x is copy, @y) {
    my @result = (0);
    for @y -> $y {
        my @addend = multby(@x, $y);
        @result = add(@result, @addend);
        @x.unshift(0);
    }
    return @result;
}

# vim: expandtab shiftwidth=4 ft=perl6
