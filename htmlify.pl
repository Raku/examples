use v6;

use lib 'lib';
use Pod::Htmlify;
use Perl6::Examples;

my %base-categories-table =
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

my $all-categories = Categories.new(categories-table => %base-categories-table);

my %cookbook-categories-table =
    "01strings"                  => "Strings",
    "02numbers"                  => "Numbers",
    "03dates-and-times"          => "Dates and Times",
    "04arrays"                   => "Arrays",
    "05hashes"                   => "Hashes",
    "07file-access"              => "File access",
    "09directories"              => "Directories",
    "10subroutines"              => "Subroutines",
    "13classes-objects-and-ties" => "Classes, Objects and Ties",
;

my $cookbook-categories = Categories.new(categories-table => %cookbook-categories-table);
$all-categories.append-subcategories(to-category => "cookbook", subcategories => $cookbook-categories);

my %wsg-categories-table =
    "beginner-2007" => "Beginner-level problems 2007",
    "beginner-2008" => "Beginner-level problems 2008",
    "advanced-2008" => "Advanced-level problems 2008",
;

my $wsg-categories = Categories.new(categories-table => %wsg-categories-table);
$all-categories.append-subcategories(to-category => "wsg", subcategories => $wsg-categories);

my %categories = %base-categories-table;

my %examples = collect-example-metadata($all-categories);


write-index;
write-index-files(%categories, %examples);

my $website = Website.new;
$website.create-category-dirs($all-categories);

write-example-files(%examples);

# vim: expandtab shiftwidth=4 ft=perl6
