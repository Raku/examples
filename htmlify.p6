use v6;

use Pod::Htmlify;
use Examples::Categories;

sub MAIN(:$no-highlight = False) {
    my @categories =
            { :url<best-of-rosettacode>, :full-name("Best of Rosettacode"),
              :short-name("Rosettacode"), :desc("The best of the rosettacode.org examples") },
            { :url<99-problems>, :full-name("99 Problems"),
              :short-name("99 problems"), :desc("Based on lisp 99 problems") },
            { :url<cookbook>, :full-name("Cookbook examples"),
            :short-name("Cookbook"), :desc("Cookbook examples") },
            { :url<euler>, :full-name("Project Euler"),
            :short-name("Euler"), :desc("Answers for Project Euler") },
            { :url<games>, :full-name("Games"),
            :short-name("Games"), :desc("Games written in Raku") },
            { :url<interpreters>, :full-name("Interpreters"),
            :short-name("Interpreters"), :desc("Language or DSL interpreters") },
            { :url<module-management>, :full-name("Module management"),
            :short-name("Modules"), :desc("Examples of organising modules") },
            { :url<parsers>, :full-name("Parsers"),
            :short-name("Grammars"), :desc("Example grammars") },
            { :url<perlmonks>, :full-name("Perlmonks"),
            :short-name("Perlmonks"), :desc("Answers to perlmonks.org questions") },
            { :url<rosalind>, :full-name("Project Rosalind"),
            :short-name("Rosalind"), :desc("Bioinformatics-related programming problems") },
            { :url<shoutout>, :full-name("Shootout"),
            :short-name("Shoutout"), :desc("Implementations for the Computer Language Benchmark Game") },
            { :url<tutorial>, :full-name("Raku Tutorial Examples"),
            :short-name("Tutorial"), :desc("Initial work in collecting Raku tutorial examples") },
            { :url<wsg>, :full-name("Winter Scripting Games"),
            :short-name("WSG"), :desc("Answers for the Winter Scripting Games") },
            { :url<other>, :full-name("Other examples"),
            :short-name("Other"), :desc("Other examples which aren't yet categorized") };

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
    $website.syntax-highlighting = !$no-highlight;
    $website.menu-tabs = %menu-tabs;
    $website.build;
}

# vim: expandtab shiftwidth=4 ft=perl6
