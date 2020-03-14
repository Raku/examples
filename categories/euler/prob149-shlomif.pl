use v6;

=begin pod

=TITLE Searching for a maximum-sum subsequence

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=149>

Looking at the table below, it is easy to verify that the maximum possible sum
of adjacent numbers in any direction (horizontal, vertical, diagonal or
anti-diagonal) is 16 (= 8 + 7 + 1).

=begin table
−2   5   3  2
 9  −6   5  1
 3   2   7  3
−1   8  −4  8
=end table

Now, let us repeat the search, but on a much larger scale:

First, generate four million pseudo-random numbers using a specific form of
what is known as a "Lagged Fibonacci Generator":

For 1 ≤ k ≤ 55, sk = [100003 − 200003k + 300007k3] (modulo 1000000) − 500000.
For 56 ≤ k ≤ 4000000, sk = [sk−24 + sk−55 + 1000000] (modulo 1000000) − 500000.

Thus, s10 = −393027 and s100 = 86613.

The terms of s are then arranged in a 2000×2000 table, using the first 2000
numbers to fill the first row (sequentially), the next 2000 numbers to fill the
second row, and so on.

Finally, find the greatest sum of (any number of) adjacent entries in any
direction (horizontal, vertical, diagonal or anti-diagonal).

=end pod

class FiboRand {
    has $.k is rw = 1;
    has @.last_nums is rw;

    method fetch() {
        my $k = $.k;
        my $s_k;

        if ($k <= 55) {
            $s_k = (((100003 - 200003*$k + 300007*($k**3)) % 1000000) - 500000);
        }
        else {
            $s_k = (((@.last_nums[*-24] + @.last_nums[*-55] + 1000000) % 1000000) - 500000);
            shift(@.last_nums);
        }
        push @.last_nums, $s_k;
        $.k++;

        return $s_k;
    }
}

# Unit test to the randomizer.
{
    my $rand = FiboRand.new;

    for 1 .. 9 -> $k {
        $rand.fetch();
    }

    if ($rand.fetch() != -393027) {
        die "Wrong s10!";
    }

    for 11 .. 99 -> $k {
        $rand.fetch();
    }

    if ($rand.fetch() != 86613) {
        die "Wrong s100!";
    }
}

class Max {
    has $.s is rw = 0;
    has $.e is rw = 0;
    method add($n) {
        $.s = max($.s, ($.e = max($.e + $n, 0)));

        return;
    }

    # g = get()
    method g() {
        return $.s;
    }
}

my $rand = FiboRand.new;

my $SIZE = 2_000;

my $max_max = 0;
my @vert_max = map { Max.new }, (1 .. $SIZE);
my @diag_max = map { Max.new }, (1 .. $SIZE);
my @anti_diag_max = map { Max.new }, (1 .. $SIZE);

my $diag_offset = 0;
my $anti_diag_offset = 0;

sub handle_row() {
    my $horiz = Max.new;
    # First row.
    for 0 .. $SIZE-1 -> $x {
        my $s = $rand.fetch();

        @vert_max[$x].add($s);
        $horiz.add($s);
        @diag_max[($x+$diag_offset) % $SIZE].add($s);
        @anti_diag_max[($x+$anti_diag_offset) % $SIZE].add($s);
    }

    $max_max = max(
        $max_max, $horiz.g(), @diag_max[0].g(), @anti_diag_max[*-1].g()
    );

    @diag_max[0] = Max.new;
    $diag_offset++;

    @anti_diag_max[*-1] = Max.new;
    $anti_diag_offset--;

    return;
}

for 1 .. $SIZE -> $y {
    print "Y=$y\n";
    handle_row();
}


print "Result = ", max(
    $max_max, (map { $_.g() }, @vert_max, @diag_max, @anti_diag_max
)
), "\n";

# vim: expandtab shiftwidth=4 ft=perl6
