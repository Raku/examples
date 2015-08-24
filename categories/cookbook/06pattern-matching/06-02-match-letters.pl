use v6;

=begin pod

=TITLE Matching alphabetic wide characters 

You want to match alphabetic characters which include unicode

=AUTHOR stmuk

=end pod

my $var = "\c[OGHAM LETTER RUIS]";
if $var ~~ /^<:letter>+$/ {   # or just /^<:L>+$/ or even  /^\w+$/ 
    say "{$var}  is purely alphabetic";
}

# vim: expandtab shiftwidth=4 ft=perl6
