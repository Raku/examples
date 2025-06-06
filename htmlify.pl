use v6;

use lib 'lib';
use Pod::Htmlify;
use Examples::Categories;

sub MAIN(:$no-highlight = False) {
    my %base-categories-table =
            "best-of-rosettacode" => "Best of Rosettacode",
            "99-problems"         => "99 problems",
            "cookbook"            => "Cookbook examples",
            "euler"               => "Answers for Project Euler",
            "games"               => "Games written in Raku",
            "interpreters"        => "Language or DSL interpreters",
            "module-management"   => "Module management",
            "parsers"             => "Example grammars",
            "rosalind"            => "Bioinformatics programming problems",
            "shootout"            => "The Computer Language Benchmark Game",
            "tutorial"            => "Tutorial examples",
            "wsg"                 => "The Winter Scripting Games",
            "other"               => "Uncategorized examples",
    ;

    my %menu-tabs =
        "/categories/best-of-rosettacode.html" => "Rosettacode",
        "/categories/99-problems.html"         => "99 Problems",
        "/categories/cookbook.html"            => "Cookbook",
        "/categories/euler.html"               => "Euler",
        "/categories/games.html"               => "Games",
        "/categories/interpreters.html"        => "Interpreters",
        "/categories/module-management.html"   => "Modules",
        "/categories/parsers.html"             => "Grammars",
        "/categories/rosalind.html"            => "Rosalind",
        "/categories/shootout.html"            => "Shootout",
        "/categories/tutorial.html"            => "Tutorial",
        "/categories/wsg.html"                 => "WSG",
        "/categories/other.html"               => "Other",
    ;

    my $all-categories = Categories.new(categories-table => %base-categories-table);

    my %cookbook-categories-table =
        "01strings"                  => "1. Strings",
        "02numbers"                  => "2. Numbers",
        "03dates-and-times"          => "3. Dates and Times",
        "04arrays"                   => "4. Arrays",
        "05hashes"                   => "5. Hashes",
        "06pattern-matching"         => "6. Pattern Matching",
        "07file-access"              => "7. File access",
        "08file-contents"            => "8. File contents",
        "09directories"              => "9. Directories",
        "10subroutines"              => "10. Subroutines",
        "13classes-objects-and-ties" => "13. Classes, Objects and Ties",
        "14database-access"          => "14. Database Access",
        "15interactivity"            => "15. Interactivity",
        "16processes"                => "16. Processes",
        "17sockets"                  => "17. Sockets",
        "19cgi-programming"          => "19. CGI programming",
        "20web-automation"           => "20. Web Automation",
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

    my $website = Website.new(categories => $all-categories);
    $website.syntax-highlighting = False if $no-highlight;
    $website.menu-tabs = %menu-tabs;
    $website.build;
}

# vim: expandtab shiftwidth=4 ft=perl6
