use v6;

=begin pod

=TITLE Tri-colouring a triangular grid

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=189>

Consider the following configuration of 64 triangles (see the web page for the image):

We wish to colour the interior of each triangle with one of three colours: red,
green or blue, so that no two neighbouring triangles have the same colour. Such
a colouring shall be called valid. Here, two triangles are said to be
neighbouring if they share an edge.

Note: if they only share a vertex, then they are not neighbours.

For example, here is a valid colouring of the above grid (see the web page for the image):

A colouring C' which is obtained from a colouring C by rotation or reflection
is considered distinct from C unless the two are identical.

How many distinct valid colourings are there for the above configuration?

=end pod

my %colors = ('00' => ['1','2'], '11' => ['0','2'], '22' => ['0','1'],
    '01' => ['2'], '10' => ['2'],
    '02' => ['1'], '20' => ['1'],
    '12' => ['0'], '21' => ['0'],
);

my %l_colors = ('0' => ['1','2'], '1' => ['0','2'], '2' => ['0','1']);

sub my_find(Int $wanted_h) returns Int {
    # The start_data for $h == 1
    my $this_seqs = {'0' => 1, '1' => 1, '2' => 1,};
    my $prev_deriveds = {
        '' => {
            '0' => 1,
            '1' => 1,
            '2' => 1,
        }
    };

    my $total_count;

    for (1 ..^ $wanted_h) -> $h {
        $total_count = 0;
        my $next_deriveds = {};
        my $next_seqs = {};

        for $this_seqs.kv -> $seq, $seq_count {
            my $seq_ders = ($next_deriveds{$seq} //= {});
            for ($prev_deriveds{$seq.substr(0, *-1)}).kv -> $left, $left_count {
                my $delta = $seq_count * $left_count;
                # say "F = <{$seq.substr(*-1) ~ $left.substr(*-1)}>";
                for %colors{$seq.substr(*-1) ~ $left.substr(*-1)}.values -> $lefter_tri_color {
                    # say "Lefter = <$lefter_tri_color>";
                    for %l_colors{$lefter_tri_color}.values -> $leftest_color {
                        # say "L = <$left> LEST = <$leftest_color>";
                        # say "delta = <$delta> left_count = <$left_count>";
                        my $str = $left ~ $leftest_color;

                        $total_count += $delta;
                        ($next_seqs{$str} //= 0) += $delta;
                        ($seq_ders{$str} //= 0) += $left_count;
                    }
                }
            }
        }

        # Fill the next data.
        ($this_seqs, $prev_deriveds) = ($next_seqs, $next_deriveds);
        say "Count[{$h+1}] = $total_count";
    }

    return $total_count;
}

# Test
{
    say my_find(2), " should be 3*2*2*2 == 24";
}
say "Result[8] = ", my_find(8);

# vim: expandtab shiftwidth=4 ft=perl6
