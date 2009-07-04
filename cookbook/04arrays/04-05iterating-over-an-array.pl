use v6;

=begin pod
=head1 Iterating Over an Array

You want to iterate over the elements in an array

=end pod


my @a = <94 13 97 95 12 13 74 10 47 4 62 47 75 36 25 35 0 71 56 50 72 39 30 93>;

for @a -> $e {
    say $e;
}

say $_ for @a;
