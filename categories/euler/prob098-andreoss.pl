use v6;

=begin pod

=TITLE Anagramic squares

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=98>

By replacing each of the letters in the word CARE with 1, 2, 9, and 6
respectively, we form a square number: 1296 = 36². What is remarkable is
that, by using the same digital substitutions, the anagram, RACE, also forms
a square number: 9216 = 96². We shall call CARE (and RACE) a square anagram
word pair and specify further that leading zeroes are not permitted, neither
may a different letter have the same digital value as another letter.

Using words.txt
L<https://projecteuler.net/project/resources/p098_words.txt>, a 16K text
file containing nearly two-thousand common English words, find all the
square anagram word pairs (a palindromic word is NOT considered to be an
anagram of itself).

What is the largest square number formed by any member of such a pair?

NOTE: All anagrams formed must be contained in the given text file.

=end pod

sub correspond([$word1, $word2], [$num1, $num2]) {
    $word2.trans($word1 => ~$num1) eq $num2   &&
    $num2.trans( ~$num1 => $word1) eq $word2;

}

sub anagrams(@x) {
    my %aux;
    my %result;

    %aux{$_.comb.sort.join}.push: $_
        for @x;

    for %aux.kv -> $k, @v {
        next if +@v < 2; ;
        %result{@v[0].chars}.push:
                +@v == 2
                  ?? @v.item
                  !! |@v.combinations(2).map(*.item);
    }

    %result;
}


sub MAIN(Bool :$verbose = False,
         Str  :$file    = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'words.txt')) {

    die "$file is missing" unless $file.IO.e;

    my @words = sort unique $file.IO.slurp.split: / <[,"]>+ /;

    my %words   =  anagrams(@words);
    my $longest-word = %words.keys.max;

    my %squares =  anagrams(
        (1 ... (10**($longest-word + 1).sqrt)) »**» 2
    );

    say max do for 3 ... $longest-word -> \size {
        next unless %words{size};
        |do for @(%words{size}) -> @pair {
            next unless %squares{size};
            |do for @(%squares{size}) -> @nums {
                if correspond(@pair, @nums) {
                    $verbose and say "@pair[] => @nums[]" ;
                    max @nums;
                }
            }
        }
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
