#!/usr/bin/env perl6

# The Expat License
#
# Copyright (c) 2018, Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class XY { has $.x = 0; has $.y = 0; };
multi infix:<+> (XY \a, XY \o) {
    a.clone: |([«+»] (a, o)».Capture».hash)
};
multi infix:<-> (XY \a, XY \o) {
    a.clone: |([«-»] (a, o)».Capture».hash)
};
class State {
    has $.cur is rw = XY.new;
    has $.dir1 is rw = 0;
    has $.n is rw = 0;
};
multi infix:<+> (State \a, State \o) {
    a.clone: |([«+»] (a, o)».Capture».hash)
};
multi infix:<-> (State \a, State \o) {
    a.clone: |([«-»] (a, o)».Capture».hash)
};

sub master($maxdepth, $mn)
{
my $s1 = State.new;
my %Cache;
my @dirs = [XY.new(x=> 0, y=> 1), XY.new(x=> 1, y=> 0), XY.new(x=> 0, y=> -1), XY.new(x=> -1, y=> 0) ];
my $printed = False;

sub dragon($depth, $seq)
{
    my $init = $s1.clone;
    my $key = ($depth, $seq, ($s1.dir1 +& 3));
    if ( %Cache{$key}:exists ) {
        my $val = %Cache{$key};
        if $val.n + $s1.n < $mn {
            $s1 = $s1 + $val;
            return;
        }
    }
    for $seq.comb() -> $c {
        if $c eq 'a' {
            if $depth < $maxdepth {
                dragon($depth+1, 'aRbFR')
            }
        }
        elsif $c eq 'b' {
            if $depth < $maxdepth {
                dragon($depth+1, 'LFaLb')
            }
        }
        elsif $c eq 'R' {
            ++$s1.dir1;
        }
        elsif $c eq 'L' {
            --$s1.dir1;
        }
        elsif $c eq 'F' {
            ++$s1.n;
            $s1.cur = $s1.cur + @dirs[$s1.dir1 +& 3];
        }
        else {
            die $c;
            ...;
        }
        if $s1.n >= $mn {
            if $s1.n == $mn {
                if not $printed {
                    printf("cur = %d,%d\n", $s1.cur.x, $s1.cur.y);
                    $printed = True
                }
            }
            return;
        }
    }
    %Cache{$key} = $s1 - $init;
}
dragon(0, 'Fa');
return;
}

master(10, 500);
master(50, 1000000000000);
