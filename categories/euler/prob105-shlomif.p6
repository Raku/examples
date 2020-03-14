use v6;

=begin pod

=TITLE Special subset sums: testing

=AUTHOR Shlomi Fish

L<https://projecteuler.net/problem=105>

Let C<S(A)> represent the sum of elements in set C<A> of size C<n>. We shall
call it a special sum set if for any two non-empty disjoint subsets, C<B>
and C<C>, the following properties are true:

    S(B) ≠ S(C); that is, sums of subsets cannot be equal.
    If B contains more elements than C then S(B) > S(C).

For example, {81, 88, 75, 42, 87, 84, 86, 65} is not a special sum set
because 65 + 87 + 88 = 75 + 81 + 84, whereas {157, 150, 164, 119, 79, 159,
161, 139, 158} satisfies both rules for all possible subset pair
combinations and C<S(A) = 1286>.

Using C<sets.txt> (right click and "Save Link/Target As..."), a 4K text file
with one-hundred sets containing seven to twelve elements (the two examples
given above are the first two sets in the file), identify all the special
sum sets, C<A₁, A₂, ..., Aₖ>, and find the value of C<S(A₁) + S(A₂) + ... +
S(Aₖ)>.

NOTE: This problem is related to
L<Problem 103|https://projecteuler.net/problem=103> and
L<Problem 106|https://projecteuler.net/problem=106>.

=end pod

sub is_special_sum_set(@A)
{
    my $recurse;

    $recurse = sub ($i, $B_sum, $B_count, $C_sum, $C_count) {

        if $i == @A
        {
            if (
                (!$B_count) || (!$C_count)
                    ||
            (
                ($B_sum != $C_sum)
                    &&
                (($B_count > $C_count) ?? ($B_sum > $C_sum) !! True)
                    &&
                (($C_count > $B_count) ?? ($C_sum > $B_sum) !! True)
            )
            )
            {
                # Everything is OK.
                return;
            }
            else
            {
                # Incorrect.
                X::AdHoc.new(:payload<foo>).throw;
            }
        }

        $recurse(
            $i+1, $B_sum+@A[$i], $B_count+1, $C_sum, $C_count
        );
        $recurse(
            $i+1, $B_sum, $B_count, $C_sum+@A[$i], $C_count+1
        );
        $recurse(
            $i+1, $B_sum, $B_count, $C_sum, $C_count
        );

        return;
    };

    my $ret = True;
    $recurse(0, 0, 0, 0, 0);

    CATCH {
        when X::AdHoc { $ret = False; }
    }

    return $ret;
}

sub MAIN(:$verbose = False) {
    my $total_sum = 0;

    my $sets-file = $*SPEC.catdir($*PROGRAM-NAME.IO.dirname, 'sets.txt');
    for $sets-file.IO.lines -> $l
    {
        say "Processing $l" if $verbose;
        my @set = $l.split(',');
        if (is_special_sum_set(@set))
        {
            $total_sum += ([+] @set);
        }
    }
    $verbose ?? say "Total Sum = $total_sum" !! say $total_sum;
}
