# Test::Differences for Perl 6 (Rakudo)

use Test;

multi sub eq_or_diff($got, $expected, Str $desc) is export()
{
    is( $got, $expected, $desc ); # from module Test

    if $got ne $expected {
        say "# failed $desc";
        say "# expected: ------------";
        my @expected = $expected.split("\n");
        my $i = 0;
        say @expected.map({"#" ~ $i++ ~ "# $_"}).join("\n");
        say "# got: -----------------";
        my @got = $got.split("\n");
        $i = 0;
        while $i < @got.elems {
            my $status = "!=";
            if $i < @expected.elems and @got[$i] eq @expected[$i] {
                $status = "==";
            }
            say "#$i$status {@got[$i]}";
            $i++;
        }
    }
}

=begin pod
=head1 NAME
Test::Differences - 
=head1 TODO
Make a side by side comparison layout the way the Perl 5 version does.
=head1 SEE ALSO
The Perl 5 L<doc:Test::Differences> by Barrie Slaymaker.
=end pod
