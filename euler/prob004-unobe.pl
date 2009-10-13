use v6;

# another case where @array = %*% (100..999) would be nice to have:
# http://use.perl.org/~dpuu/journal/38142
sub diagonal_x ($array) {
    my $result = [];
    my $copy = $array;
    for $copy -> $this {
        $copy.shift;
        for $copy -> $that { $result.push($this * $that); }
    }
    return $result;
}

diagonal_x(100..999).grep({ $_ eq .flip }).sort.reverse.[0].say;
