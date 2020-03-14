use v6;

=begin pod

=TITLE Roman numerals

=AUTHOR Andrei Osipov

L<https://projecteuler.net/problem=89>

For a number written in Roman numerals to be considered valid there
are basic rules which must be followed. Even though the rules allow
some numbers to be expressed in more than one way there is always a
"best" way of writing a particular number.

For example, it would appear that there are at least six ways of
writing the number sixteen:

IIIIIIIIIIIIIIII

VIIIIIIIIIII

VVIIIIII

XIIIIII

VVVI

XVI

However, according to the rules only XIIIIII and XVI are valid, and
the last example is considered to be the most efficient, as it uses
the least number of numerals.

The 11K text file roman.txt contains one thousand numbers written in
valid, but not necessarily minimal, Roman numerals; see About... Roman
Numerals for the definitive rules for this problem.

Find the number of characters saved by writing each of these in their
minimal form.

Note: You can assume that all the Roman numerals in the file contain
no more than four consecutive identical units.

=end pod

use experimental :cached;

multi roman-to-int() { 0 }
multi roman-to-int(Str $r where $r.chars > 1 ) {
    roman-to-int(| $r.comb)
}

multi roman-to-int('I', 'X', |a) { 9   + roman-to-int |a }
multi roman-to-int('I', 'V', |a) { 4   + roman-to-int |a }
multi roman-to-int('I',      |a) { 1   + roman-to-int |a }

multi roman-to-int('X', 'L', |a) { 40  + roman-to-int |a }
multi roman-to-int('X', 'C', |a) { 90  + roman-to-int |a }
multi roman-to-int('X',      |a) { 10  + roman-to-int |a }

multi roman-to-int('C', 'M', |a) { 900 + roman-to-int |a }
multi roman-to-int('C', 'D', |a) { 400 + roman-to-int |a }
multi roman-to-int('C',      |a) { 100 + roman-to-int |a }

multi roman-to-int($v,       |a) {
    roman-to-int(|a) + do given $v {
        when 'I' { 1 }
        when 'V' { 5 }
        when 'X' { 10 }
        when 'L' { 50 }
        when 'C' { 100 }
        when 'D' { 500 }
        when 'M' { 1000 }
    }
}


sub int-to-roman(Int \n) returns Str is cached {
    given n {
        when * >= 1000 { 'M'  ~ int-to-roman(n - 1000) }
        when * >= 900  { 'CM' ~ int-to-roman(n - 900) }
        when * >= 500  { 'D'  ~ int-to-roman(n - 500) }
        when * >= 400  { 'CD' ~ int-to-roman(n - 400) }
        when * >= 100  { 'C'  ~ int-to-roman(n - 100) }
        when * >= 90   { 'XC' ~ int-to-roman(n - 90) }
        when * >= 50   { 'L'  ~ int-to-roman(n - 50) }
        when * >= 40   { 'XL' ~ int-to-roman(n - 40) }
        when * >= 10   { 'X'  ~ int-to-roman(n - 10) }
        when * >= 9    { 'IX' ~ int-to-roman(n - 9) }
        when * >= 5    { 'V'  ~ int-to-roman(n - 5) }
        when * >= 4    { 'IV' ~ int-to-roman(n - 4) }
        when * >= 1    { 'I'  ~ int-to-roman(n - 1) }
        default        { '' }
    }
}


sub MAIN(Bool :$run-tests = False,
         Str  :$file      = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'roman.txt')) {

    return TEST if $run-tests;
    die "$file is missing" unless $file.IO.e;
    say [+] do for $file.IO.lines -> $line {
        $line.chars - (int-to-roman roman-to-int $line).chars;
    }
}

sub TEST {
    use Test;

    {
        my $i = roman-to-int("XXXXVIIII");
        ok roman-to-int(int-to-roman $i) == $i, "sanity test";
    }
    {
        my $i = (^1000).pick;
        ok roman-to-int(int-to-roman $i) == $i, "sanity test";
    }

    ok (roman-to-int("IIIIIIIIIIIIIIII") ==
        roman-to-int("VIIIIIIIIIII") ==
        roman-to-int("VVIIIIII") ==
        roman-to-int("XIIIIII") ==
        roman-to-int("VVVI") ==
        roman-to-int("XVI")), 'roman-to-int works';
    is int-to-roman(6666) , "MMMMMMDCLXVI", 'int-to-roman works';
    done;
}

# vim: expandtab shiftwidth=4 ft=perl6
