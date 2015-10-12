use v6;

=begin pod

=TITLE P09 - Pack consecutive duplicates of list elements into sublists.

=AUTHOR Rob Eaglestone

=head1 Specification

   P09 (**) Pack consecutive duplicates of list elements into sublists.
       If a list contains repeated elements they should be placed in separate
       sublists.

=head1 Example

    > pack_dup(<a a a a b c c a a d e e e e>).perl.say
    [["a","a","a","a"],["b"],["c","c"],["a","a"],["d"],["e","e","e","e"]]

=end pod

# Robert Eaglestone  22 sept 09
#
#   My first Perl6 script - I'm sure this can be done better
#
my @in = <a a a a b c c a a d e e e e>;
my @out = pack_dup( @in );
@out.perl.say;

sub pack_dup(@in) {
    my @out = [ [@in.shift], ];

    for @in -> $elem {
        push @out, [] if $elem ne @out[*-1][0];
        push @out[*-1], $elem;
    }
    return @out;
}

# vim: expandtab shiftwidth=4 ft=perl6
