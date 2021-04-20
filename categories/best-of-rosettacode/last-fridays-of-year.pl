use v6;

=begin pod

=TITLE Last fridays of the year

=AUTHOR TimToady

Write a program or a script that returns the last Fridays of each month
of a given year. The year may be given through any simple input method
in your language (command line, std in, etc.).

=head1 More

L<http://rosettacode.org/wiki/Last_Fridays#Raku>

=head1 Features used

The MAIN sub - L<https://doc.perl6.org/language/functions#sub_MAIN>

Date objects - L<https://doc.perl6.org/type/Date>

=end pod

sub MAIN (Int $year = Date.today.year) {
    my @fri;
    for Date.new("$year-01-01") .. Date.new("$year-12-31") {
        @fri[.month] = .Str if .day-of-week == 5;
    }
    .say for @fri[1..12];
}

# vim: expandtab shiftwidth=4 ft=perl6
