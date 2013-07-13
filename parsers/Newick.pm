#| Newick tree format. L<https://en.wikipedia.org/wiki/Newick_format>
grammar Newick {
    rule TOP { '(' <subtree>** 2..3 % \, ');' }
    rule subtree { <species> | '(' <subtree>** 2 % \, ')' }
    token species { <.ident>+ }
}

# vim: ft=perl6

