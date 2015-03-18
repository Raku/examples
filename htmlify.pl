use v6;

use lib 'lib';
use Pod::To::Perl;
use Pod::Htmlify;
use Pod::Convenience;
use Perl6::Examples;

my %categories =
    "best-of-rosettacode" => "Best of Rosettacode",
    "99-problems"         => "99 problems",
    "cookbook"            => "Cookbook examples",
    "euler"               => "Answers for Project Euler",
    "games"               => "Games written in Perl 6",
    "interpreters"        => "Language or DSL interpreters",
    "module-management"   => "Module management",
    "parsers"             => "Example grammars",
    "perlmonks"           => "Answers to perlmonks.org questions",
    "rosalind"            => "Bioinformatics programming problems",
    "shootout"            => "The Computer Language Benchmark Game",
    "tutorial"            => "Tutorial examples",
    "wsg"                 => "The Winter Scripting Games",
    "other"               => "Uncategorized examples",
;

my %examples = collect-example-metadata(%categories);

write-index;
write-index-files(%categories, %examples);
create-category-dirs(%categories);
write-example-files(%examples);



# vim: expandtab shiftwidth=4 ft=perl6
