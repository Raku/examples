use v6;

=begin pod

=head1 Hi-Res Timings

You want to measure sub-second timings

=end pod

my $t0 = DateTime.now.Instant;

# apparently not *quite* 2 secs

sleep 2;

say  DateTime.now.Instant - $t0;

# vim: ft=perl6
