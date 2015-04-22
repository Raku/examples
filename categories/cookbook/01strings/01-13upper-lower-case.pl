use v6;

=begin pod

=TITLE Upper/Lower Case

=AUTHOR stmuk

You have a string and what to upper/lower case it

=end pod

my $string = "the cat sat on the mat";

say $string=$string.uc; # THE CAT SAT ON THE MAT 

say $string.=lc; # the cat sat on the mat 

say $string.wordcase; # The Cat Sat On The Mat 

# vim: expandtab shiftwidth=4 ft=perl6
