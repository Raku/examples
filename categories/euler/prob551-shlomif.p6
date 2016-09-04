use v6;
use MONKEY-TYPING;

=begin pod

=TITLE Sum of digits sequence

=AUTHOR Shlomi Fish

L<http://projecteuler.net/problem=551>

Let C<a₀, a₁, a₂, ...> be an integer sequence defined by:

=item a₀ = 1;

=item for C<n ≥ 1>, an is the sum of the digits of all preceding terms.

The sequence starts with 1, 1, 2, 4, 8, 16, 23, 28, 38, 49, ...
You are given C<a_{10^6} = 31054319>.

Find C<a_{10^{15}}>.

=end pod

my $NUM_DIGITS = 30;

my $NUM_FMT = '%0' ~ $NUM_DIGITS ~ 'd';

augment class Int
{
    method digits-sum() returns Int
    {
        return [+] self.comb;
    }

    method _format_n() returns Str
    {
        return $NUM_FMT.sprintf(self);
    }
}

my $A0 = 1;

class Point
{
    has Int $.n;
    # The digits sum.
    has Int $.s;
    # The index.
    has Int $.i;

    method _format() returns Str
    {
        return self.n._format_n;
    }
}

my @calced_arr;

my $a_n = Point.new(n => $A0, i => 1, s => $A0.digits-sum);

# Short for insert.
sub ins()
{
    @calced_arr.push($a_n.clone);

    return;
}

ins();


my @cache = [{} xx ($NUM_DIGITS+1)] xx ($NUM_DIGITS*9+1);

sub calc_next()
{
    my $new_n = $a_n.n + $a_n.s;
    $a_n = Point.new(n => $new_n, i => $a_n.i+1, s => $new_n.digits-sum);

    return;
}

sub _common_len(Str $s, Str $e)
{
    return -1 + (0 .. $NUM_DIGITS).first: { $s.substr($^a, 1) ne $e.substr($^a, 1) };
}

sub cache_delta()
{
    # Start and end.
    my $i = @calced_arr-2;
    my $s = @calced_arr[*-2];
    my $e = @calced_arr[*-1];
    my $s_digits = $s._format;
    my $e_digits = $e._format;
    my $l = _common_len($s_digits, $e_digits);
    for 1 .. $l -> $ll
    {
        @cache[$s.s][$ll]{$s_digits.substr($ll)} = $i;
    }
    return;
}

calc_next;
ins;
cache_delta;

sub _print_me()
{
    say "a[%d] = %d".sprintf($a_n.i, $a_n.n);
}

sub MAIN(:$LIM = 1_000_000, Bool :$verbose = False) {
    while $a_n.i < $LIM
    {
        if ($verbose) {
            _print_me if $a_n.i %% 1_000;
        }
        my $a_s = $a_n._format;
        my $to_proc = sub {
            for 1 .. $NUM_DIGITS-1 -> $i
            {
                my $sub_s = $a_s.substr($i);
                my $lookup = @cache[$a_n.s][$i];
                if $lookup{$sub_s}:exists
                {
                    my $start_arr_i = $lookup{$sub_s};
                    my $get_prefix = sub ($idx) {
                        return @calced_arr[$idx]._format().substr(0,$i);
                    };
                    my $prefix = $get_prefix.($start_arr_i);
                    my $base_idx = $a_n.i - @calced_arr[$start_arr_i].i;
                    my $end_arr_i = $start_arr_i + 1;
                    my $new_idx = sub () { return $base_idx + @calced_arr[$end_arr_i].i };
                    while $end_arr_i < @calced_arr and $get_prefix.($end_arr_i) eq $prefix and $new_idx.() <= $LIM
                    {
                        $end_arr_i++;
                    }
                    $end_arr_i--;
                    if $end_arr_i > $start_arr_i
                    {
                        $a_n = Point.new(
                            n => $a_n.n + @calced_arr[$end_arr_i].n - @calced_arr[$start_arr_i].n,
                            i => $new_idx.(),
                            s => @calced_arr[$end_arr_i].s
                        );
                        return False;
                    }
                }
            }
            return True;
        }.();

        if $to_proc
        {
            calc_next;
        }

        ins;
        cache_delta;
    }

    _print_me;
}

# vim: expandtab shiftwidth=4 ft=perl6
