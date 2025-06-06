use v6;

=begin pod

=TITLE Overlap Graphs

=AUTHOR L. Grondin

L<http://rosalind.info/problems/grph/>

Sample input

    >Rosalind_0498
    AAATAAA
    >Rosalind_2391
    AAATTTT
    >Rosalind_2323
    TTTTCCC
    >Rosalind_0442
    AAATCCC
    >Rosalind_5013
    GGGTGGG

Sample output

    Rosalind_0498 Rosalind_2391
    Rosalind_0498 Rosalind_0442
    Rosalind_2391 Rosalind_2323

=end pod

my $default-data = q:to/END/;
>Rosalind_0498
AAATAAA
>Rosalind_2391
AAATTTT
>Rosalind_2323
TTTTCCC
>Rosalind_0442
AAATCCC
>Rosalind_5013
GGGTGGG
END

sub MAIN($input-file = Nil) {
    my $input = !$input-file ?? $default-data !! $input-file.IO.slurp;

    my %dna = (gather for
        $input.match(/ ^^ '>Rosalind_' (<digit> **4) \n (<[\nACGT]>*) /, :g) {
        take ~.[0], ~.[1].subst(/\n/,'', :g);
    })>>.list.flat;

    for (%dna X %dna).flat -> $a, $b {
        next if $a.key eq $b.key;
        say "{'Rosalind_' «~« ($a, $b)».key} ".trim
        if $a.value.substr(*-3) eq $b.value.substr(0, 3);
    }
}

# vim: expandtab shiftwidth=4 ft=perl6
