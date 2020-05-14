#!/usr/bin/raku

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

sub rsum($x)
{
    return $x + Int($x.flip());
}

sub is_palindrome($int)
{
    my $s = Str($int);
    return $s.flip eq $s;
}

sub is_lycherel($start)
{
    my $n = rsum($start);
    for 1 .. 50 -> $i {
        return False if is_palindrome($n);
        $n = rsum($n);
    }
    return True;
}

if (False)
{
    say is_palindrome(11);
    say rsum(13);
}
say +((1..10000).grep( { is_lycherel($_) }));
