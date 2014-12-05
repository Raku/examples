use v6;

=begin pod

=head1 Today's Date

You want year, month and day for today's date.

=end pod

my $d = Date.today;

say "{$d.year} {$d.month} {$d.day}";

# vim: ft=perl6
