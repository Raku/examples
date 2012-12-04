use v6;

my %dna = gather for
$*IN.slurp.match( / ^^ '>Rosalind_' (<digit> **4) \n (<[\nACGT]>*) /, :g) {
    take ~.[0], ~.[1].subst(/\n/,'', :g);
}

for %dna X %dna -> $a, $b {
    next if $a.key eq $b.key;
    say 'Rosalind_' «~« ($a, $b)».key
    if $a.value.substr(*-3) eq $b.value.substr(0, 3);
}

# vim: ft=perl6
