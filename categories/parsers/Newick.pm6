use v6;

=begin pod

=TITLE Newick tree format

=AUTHOR Lucien Grondin

See L<https://en.wikipedia.org/wiki/Newick_format>.

=end pod

grammar Newick {
    rule TOP { '(' <subtree>** 2..3 % \, ');' }
    rule subtree { <species> | '(' <subtree>** 2 % \, ')' }
    token species { <.ident>+ }
}

# vim: expandtab shiftwidth=4 ft=perl6
