use v6;

my $n = 5;
my $size = $n * $n;

my @track;
my @directions = (1, -1 X 2, -2), (2, -2 X 1, -1);

sub valid_moves($curr, @temp_track=@track) {
  my @valid_squares = @directions.map(->$a,$b { ($curr.key + $a) => ($curr.value + $b) }).grep({0 <= all(.key, .value) < $n});
  # exclude occupied squares. !eqv doesn't work yet.
  @valid_squares.grep({ not $_ eqv any(@temp_track, $curr) });
}

sub knight($square) {
  @track.push($square);
  return 1 if @track.elems == $size;

  # simple heuristic, for move ordering
  my @possible_moves = valid_moves($square).sort: ->$a,$b { 
    valid_moves($a, [@track,$a]).elems <=> valid_moves($b, [@track, $b]).elems;
  };

  return unless @possible_moves.elems;

  for @possible_moves -> $try {
    my $result = knight($try);
    if $result {
      return 1;
    } else {
      @track.pop;
    } 
  }
}

if knight(0 => 0) {
  say "FOUND: " ~ @track.perl;
} else {
  say "NOT FOUND";
}

