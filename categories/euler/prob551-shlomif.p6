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

=head2 Usage

By default the code will only run up to C<a[1_000_000]>; to run the full
version, specify the C<--LIM> option on the command line.  For progress
output, specify the C<--verbose> option.  E.g.

    perl6 categories/euler/prob551-shlomif.p6 --LIM=1_000_000_000_000_000 --verbose

=end pod

my $NUM_DIGITS = 30;

augment class Int
{
    method digits-sum() returns Int
    {
        [+] self.comb;
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
        0 x (30 - self.n.chars) ~ self.n;
    }
}

my @calced_arr;

my $a_n = Point.new(n => $A0, i => 1, s => $A0.digits-sum);

# Short for insert.
sub ins(-->Nil)
{
    @calced_arr.push($a_n.clone);
}

ins();


my @cache = [{} xx ($NUM_DIGITS+1)] xx ($NUM_DIGITS*9+1);

sub calc_next(-->Nil)
{
    my $new_n = $a_n.n + $a_n.s;
    $a_n = Point.new(n => $new_n, i => $a_n.i+1, s => $new_n.digits-sum);
}

sub _common_len(Str $s, Str $e)
{
    -1 + (0 .. $NUM_DIGITS).first: { $s.substr($^a, 1) ne $e.substr($^a, 1) };
}

sub cache_delta(-->Nil)
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
                        @calced_arr[$idx]._format().substr(0,$i);
                    };
                    my $prefix = $get_prefix.($start_arr_i);
                    my $base_idx = $a_n.i - @calced_arr[$start_arr_i].i;
                    my $end_arr_i = $start_arr_i + 1;
                    my $new_idx = sub () { $base_idx + @calced_arr[$end_arr_i].i; };
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
            True;
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
