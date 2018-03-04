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


my $BASE = 1000000000;


sub calc_S(int $n, $token='foo')
{
    my $out = run('primesieve', $n, '-p1', :out).out.slurp-rest;
    my int @primes = map { Int($_) }, split /\n/, $out;

    return 0 if !@primes;

    my int @d;
    my int $r = 1;

    for 0..$n -> $m
    {
        if $m +& 1
        {
            @d.push(0);
        }
        else
        {
            @d.push($r);
            $r = (($r +< 1) % $BASE);
        }
    }

    @primes.shift;

    while @primes {
        my int $p = @primes.shift;
        for $p .. $n -> $m {
            my int $one = @d.AT-POS($m);
            my int $two = $p * @d.AT-POS($m-$p);
            my int $three = $one + $two;
            @d.ASSIGN-POS($m, $three % $BASE);
        }
        say $token, ' ', $p, ' ', @d[$p];
    }

    return @d;
}

my $a = 1;
my $b = 1;
my @Fk;
for 2.. 24 -> $i
{
    @Fk.push($b);
    ($a, $b) = ($b, $a+$b);
}
say "a = $a";
my int @ret := calc_S($a, "$a");
# assert ret[8] == 49
# assert ret[1] == 0
# assert ret[2] == 2
# assert ret[3] == 3
# assert ret[5] == 11
my $r = sum(@ret[@Fk]);
printf("ret = %d ; %09d\n",  $r, $r % $BASE);
