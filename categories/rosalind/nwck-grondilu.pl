use v6;

=begin pod

=TITLE Distances in Trees

=AUTHOR L. Grondin

L<http://rosalind.info/problems/nwck/>

Sample input

    (cat)dog;
    dog cat

    (dog,cat);
    dog cat

Note: a trailing newline is necessary in the input data so that the input is
divisible by three.

Sample output

    1 2


=end pod

my $default-data = q:to/END/;
    (cat)dog;
    dog cat

    (dog,cat);
    dog cat

    END

sub MAIN($input-file = Nil) {
    my $input = $input-file ?? $input-file.IO.slurp !! $default-data;
    say gather for $input.lines.list -> $newick, $taxa, $ {
        my ($a, $b) = $taxa.split: ' ';
        my @token = $newick.comb: rx/ <.ident>+ | <[(),]> /;
        Nil while @token.shift ne $a|$b;
        my ($climbs, $descents) = 0 xx 2;
        for @token {
            last if $_ eq $a or $_ eq $b;
            if /< , ) >/ {
                if $descents > 0 { $descents-- }
                else { $climbs++ }
            }
            if /< , ( >/ { $descents++ }
        }
        take $climbs + $descents;
    }.join(" ");
}

# vim: expandtab shiftwidth=4 ft=perl6
