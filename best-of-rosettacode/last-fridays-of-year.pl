# http://rosettacode.org/wiki/Last_Fridays#Perl_6
#
# Write a program or a script that returns the last Fridays of each month
# of a given year. The year may be given through any simple input method
# in your language (command line, std in, etc.). 

sub MAIN (Int $year = Date.today.year) {
    my @fri;
    for Date.new("$year-01-01") .. Date.new("$year-12-31") {
        @fri[.month] = .Str if .day-of-week == 5;
    }
    .say for @fri[1..12];
}

# The MAIN sub: http://perlcabal.org/syn/S06.html#Declaring_a_MAIN_subroutine
# Date objects: http://perlcabal.org/syn/S32/Temporal.html#Date
# 
# vim: expandtab shiftwidth=4 ft=perl6:
