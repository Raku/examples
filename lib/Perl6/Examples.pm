module Perl6::Example;

use v6;

#| Encapsulates an example's metadata
class Example is export {
    has $.title is rw;
    has $.author is rw;
    has $.category is rw;
    has $.subcategory is rw;
    has $.filename is rw;
    has $.pod-link is rw;
    has $.pod-contents is rw;
}

#| Encapsulates a category's metadata
class Category is export {
    has $.key is rw;
    has $.title is rw;
    has @.subcategories is rw;
}

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

my %wsg-categories-table =
    "beginner-2007" => "Beginner-level problems 2007",
    "beginner-2008" => "Beginner-level problems 2008",
    "advanced-2008" => "Advanced-level problems 2008",
;

sub get-categories(%categories) is export {
    my @categories = categories-list(%categories);
    @categories = append-subcategories(@categories);

    return @categories;
}

sub append-subcategories(@categories) {
    for @categories -> $category {
        given $category.key {
            when "cookbook" {
                $category.subcategories =
                    categories-list(%cookbook-categories-table);
            }
            when "wsg" {
                $category.subcategories =
                    categories-list(%wsg-categories-table);
            }
        }
    }

    return @categories;
}

sub categories-list(%categories) {
    return gather for %categories.keys -> $subcategory {
        take Category.new(key => $subcategory, title => %categories{$subcategory});
    }
}

my @categories = get-categories(%categories);

# vim: expandtab shiftwidth=4 ft=perl6
