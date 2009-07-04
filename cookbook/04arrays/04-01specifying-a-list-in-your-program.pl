use v6;

=begin pod
=head1 Specifying a list in your program

You want to include a list in your program.  This is how to initialize arrays.

=end pod

# comma separated list of elements
my @a = ('alpha', 'beta', 'gamma');
say @a[1];

# angle brackes to autoquote items
my @a = <alpha beta gamma>;

for @a -> $e {
    say $e;
}
