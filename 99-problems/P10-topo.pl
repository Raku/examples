#!/usr/bin/env perl6
use v6;

sub encode(@list)
{
    gather while @list.elems
    {
        my $value = @list[0];
        my $count = 0;

        take [
            while @list.elems
              and @list[0] ~~ $value
            {
                $count++;
                shift @list
            }

            $count, $value
        ]
    }
}

say encode(<a a a a a b b c b d e e>.list).perl;

=begin pod

=head1 NAME

P10 - Run-length encoding of a list.

=end pod

# vim: ft=perl6
