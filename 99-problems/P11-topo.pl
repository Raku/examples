#!/usr/bin/env perl6
use v6;

sub encode(@list)
{
    gather while @list.elems
    {
        my $value = @list[0];
        my $count = 0;

        take (
            while @list.elems
              and @list[0] ~~ $value
            {
                $count++;
                shift @list
            }

            $count == 1 ?? $value !! [$count, $value]
        )
    }
}

say encode(<a a a a b c c a a d e e e e>.list).perl;

=begin pod

=head1 NAME

P11 - Modified run-length encoding.

=end pod

# vim: ft=perl6
