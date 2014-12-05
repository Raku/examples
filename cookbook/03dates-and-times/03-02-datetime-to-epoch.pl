use v6;

=begin pod

=head1 DateTime to Epoch Seconds 

You want a datetime (ISO 8601) as seconds past the epoch.

=end pod

my $dt = DateTime.new("1981-06-17T00:00:00Z");

say $dt.posix;

# vim: ft=perl6
