use v6;

=begin pod

=TITLE P17 - Split a list into two parts; the length of the first part is given.

=AUTHOR Ryan Connelly

=head1 Example

    > say split-list(('a' xx 10).list, 8).perl;
    (["a", "a", "a", "a", "a", "a", "a", "a"], ["a", "a"]).list

=end pod

sub split-list(@list, $length)
{
    my $i = 0;

    gather while $i <= $length {
        take [ gather while $i <= $length {
            $i++ and take @list.[0];
        } ];

        take [ @list ];
    }
}

say split-list(('a' xx 20).list, 8).list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
