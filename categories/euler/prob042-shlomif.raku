use v6;

=begin pod

=TITLE Coded triangle numbers

=AUTHOR Shlomi Fish

The nth term of the sequence of triangle numbers is given by, tn = ½n(n+1); so the first ten triangle numbers are:

1, 3, 6, 10, 15, 21, 28, 36, 45, 55, ...

By converting each letter in a word to a number corresponding to its alphabetical position and adding these values we form a word value. For example, the word value for SKY is 19 + 11 + 25 = 55 = t10. If the word value is a triangle number then we shall call the word a triangle word.

Using words.txt (right click and 'Save Link/Target As...'), a 16K text file containing nearly two-thousand common English words, how many are triangle words?

=end pod

sub is_triangle($half)
{
    my $n = $half +< 1;

    my $i = Int( sqrt($n) );

    if $i * $i == $n
    {
        return False;
    }
    return $n == $i * ( $i + 1 );
}

sub MAIN(:$verbose = False) {
    my $total_sum = 0;

    my $words-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'words.txt');
    my $text = $words-file.IO.slurp;
    my @words = $text ~~ m:global/<[A .. Z]>+/;
    my $RESULT = +(@words.grep(sub ($_) { is_triangle( sum( map { $_.ord - 'A'.ord + 1 },$_.comb) ) }));
    say $RESULT;
}
