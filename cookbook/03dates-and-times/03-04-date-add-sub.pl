use v6;

=begin pod

=head1 Adding and Subtracting Dates

You want to calculate a past or future timeday from a given one.

=end pod

# the past using whole days

my $wall = Date.new("1981-06-17");
say ($wall-28);

# the future with datetimes

my $dt = DateTime.new("1981-06-17T20:00:00Z");
say $dt.later(:week(2));

# vim: expandtab shiftwidth=4 ft=perl6
