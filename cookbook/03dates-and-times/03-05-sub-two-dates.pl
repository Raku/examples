use v6;

=begin pod

=head1 Subtracting Two Dates From Each other

Subtracting Two Dates From Each other returning days

=end pod

# the past using whole days

my $past-day = Date.new("1966-08-04");

my $off-work = Date.new("2014-12-05");

say $off-work - $past-day ;

# vim: ft=perl6
