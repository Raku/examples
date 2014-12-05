use v6;

=begin pod

=head1 Epoch Seconds to DateTime 

You want to convert as seconds past the epoch to a datetime (ISO 8601) 

=end pod

my $now = 1417793234;
my $dt = DateTime.new($now);

say $dt;

# vim: ft=perl6
