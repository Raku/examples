use v6;

=begin pod

=head1 Delete File

You want to delete a file

=end pod

# create a file
my $f = open "foo",:w;
$f.print(time);
$f.close;

unlink "foo";

# vim: expandtab shiftwidth=4 ft=perl6
