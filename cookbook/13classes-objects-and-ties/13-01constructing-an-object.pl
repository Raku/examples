use v6;

=begin pod
=head1 Constructing an object

=head2 Problem

You want to create a way for your users to generate new objects

=head2 Solution

Merely declare the class.  Constructors are provided for you automatically.

=end pod

class Foo {}

my $foo = Foo.new;
say $foo.isa('Foo') ?? "Yes" !! "No";
