use v6;

=begin pod

=head1 Last fridays of the year

Write a program or a script that returns the last Fridays of each month
of a given year. The year may be given through any simple input method
in your language (command line, std in, etc.). 

=head1 More

L<http://rosettacode.org/wiki/Last_Fridays#Perl_6>

=end pod


sub MAIN (Int $year = Date.today.year) {
    my @fri;
    for Date.new("$year-01-01") .. Date.new("$year-12-31") {
        @fri[.month] = .Str if .day-of-week == 5;
    }
    .say for @fri[1..12];
}


=begin pod

=head1 Features used

The MAIN sub - L<http://perlcabal.org/syn/S06.html#Declaring_a_MAIN_subroutine>

Date objects - L<http://perlcabal.org/syn/S32/Temporal.html#Date>

=end pod
 
# vim: expandtab shiftwidth=2 ft=perl6:
