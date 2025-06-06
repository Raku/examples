use v6;

=begin pod

=TITLE P12 - Decode modified run-length encoding.

=AUTHOR Ryan Connelly

=head1 Example

    > say decode(([5, "a"], [2, "b"], "c", "b", "d", [2, "e"]).list).perl;
    ("a", "a", "a", "a", "a", "b", "b", "c", "b", "d", "e", "e").list

=end pod

sub decode(@list)
{
    gather for @list -> $e
    {
        $e !~~ Array ?? take($e) !! take(($e[1] xx $e[0]).list)
    }
}

say decode(([5, "a"], [2, "b"], "c", "b", "d", [2, "e"]).list).flat.list.perl;

# vim: expandtab shiftwidth=4 ft=perl6
