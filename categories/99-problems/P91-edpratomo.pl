use v6;

=begin pod

=TITLE P91 - Knight's tour.

=AUTHOR Edwin Pratomo

=head1 Specification

   P91 (**) Knight's tour
       Another famous problem is this one: How can a knight jump on an NxN
       chessboard in such a way that it visits every square exactly once?

       Hints: Represent the squares by pairs of their coordinates of the form
       X/Y, where both X and Y are integers between 1 and N. (Note that '/'
       is just a convenient functor, not division!) Define the relation
       jump(N,X/Y,U/V) to express the fact that a knight can jump from X/Y to
       U/V on a NxN chessboard. And finally, represent the solution of our
       problem as a list of N*N knight positions (the knight's tour).

=end pod

my $n = 5;
my $size = $n * $n;

my @track;
my @directions = flat ((1, -1 X 2, -2), (2, -2 X 1, -1));

sub valid_moves($curr, @temp_track=@track) {
    my @valid_squares = @directions.map(->$a,$b { ($curr.key + $a) => ($curr.value + $b) }).grep({0 <= all(.key, .value) < $n});
    # exclude occupied squares. !eqv doesn't work yet.
    @valid_squares.grep({ not $_ eqv any(|@temp_track, $curr) });
}

sub knight($square) {
    @track.push($square);
    return 1 if @track.elems == $size;

    # simple heuristic, for move ordering
    my @possible_moves = valid_moves($square).sort: ->$a,$b {
        valid_moves($a, [|@track,$a]).elems <=> valid_moves($b, [|@track, $b]).elems
            or $a.key <=> $b.key
            or $a.value <=> $b.value;
    };

    return unless @possible_moves.elems;

    for @possible_moves -> $try {
        my $result = knight($try);
        if $result {
            return 1;
        }
        else {
            @track.pop;
        }
    }
}

if knight(0 => 0) {
    say "FOUND: " ~ @track.perl;
}
else {
    say "NOT FOUND";
}

# vim: expandtab shiftwidth=4 ft=perl6
