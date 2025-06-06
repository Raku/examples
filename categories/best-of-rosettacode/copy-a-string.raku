use v6;

=begin pod

=TITLE Copy a string

=AUTHOR Stephen "thundergnat" Schulze

This task is about copying a string. Where it is relevant, distinguish
between copying the contents of a string versus making an additional
reference to an existing string.

=head2 More

L<http://rosettacode.org/wiki/Copy_a_string#Raku>

=end pod

# There is no special handling needed to copy a string.
{
    my $original = 'Hello.';
    my $copy = $original;
    say $copy;            # prints "Hello."
    $copy = 'Goodbye.';
    say $copy;            # prints "Goodbye."
    say $original;        # prints "Hello."
}

# You can also bind a new variable to an existing one so that each refers
# to, and can modify the same string.
{
    my $original = 'Hello.';
    my $bound := $original;
    say $bound;           # prints "Hello."
    $bound = 'Goodbye.';
    say $bound;           # prints "Goodbye."
    say $original;        # prints "Goodbye."
}

# vim: expandtab shiftwidth=4 ft=perl6
