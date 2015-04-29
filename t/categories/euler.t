use v6;

use Test;

plan 45;

subtest {
    plan 5;

    my $problem = "prob001";
    my @authors = <cspencer eric256 grondilu hexmode unobe>;
    my $expected-output = 233168;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "prob001";

subtest {
    plan 3;

    my $problem = "prob002";
    my @authors = <eric256 gerdr hexmode>;
    my $expected-output = 4613732;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob002";

subtest {
    plan 4;

    my $problem = "prob003";
    my @authors = <eric256 gerdr hexmode lanny>;
    my $expected-output = 6857;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob003";

subtest {
    plan 1;

    my $problem = "prob004";
    my @authors = <unobe>;
    my $expected-output = 906609;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob004";

subtest {
    plan 2;

    my $problem = "prob005";
    my @authors = <unobe xfix>;
    my $expected-output = 232792560;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob005";

subtest {
    plan 1;

    my $problem = "prob006";
    my @authors = <polettix>;
    my $expected-output = 25164150;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob006";

subtest {
    plan 1;

    my $problem = "prob007";
    my @authors = <polettix>;
    my $expected-output = 104743;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob007";

subtest {
    plan 2;

    my $problem = "prob008";
    my @authors = <duff duff2>;
    my $expected-output = 40824;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob008";

subtest {
    plan 3;

    my $problem = "prob009";
    my @authors = <gerdr-feeds gerdr polettix>;
    my $expected-output = 31875000;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob009";

skip("prob010-polettix.pl takes too long to run");
if False {
    subtest {
        plan 1;

        my $problem = "prob010";
        my @authors = <polettix>;
        my $expected-output = 142913828922;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob010";
}

subtest {
    plan 1;

    my $problem = "prob011";
    my @authors = <moritz>;
    my $expected-output = 70600674;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob011";

skip("prob012-polettix.pl uses too much memory");
if False {
    subtest {
        plan 1;

        my $problem = "prob012";
        my @authors = <polettix>;
        my $expected-output = 76576500;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob012";
}

subtest {
    plan 1;

    my $problem = "prob013";
    my @authors = <grondilu>;
    my $expected-output = 5537376230;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob013";

skip("prob014-felher.pl takes too long and uses too much memory");
if False {
    subtest {
        plan 1;

        my $problem = "prob014";
        my @authors = <felher>;
        my $expected-output = "the starting number 837799 produces a sequence of 525";

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob014";
}

subtest {
    plan 1;

    my $problem = "prob015";
    my @authors = <felher>;
    my $expected-output = 137846528820;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob015";

subtest {
    plan 1;

    my $problem = "prob016";
    my @authors = <grondilu>;
    my $expected-output = 1366;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob016";

subtest {
    plan 1;

    my $problem = "prob017";
    my @authors = <duff>;
    my $expected-output = 21124;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob017";

subtest {
    plan 1;

    my $problem = "prob018";
    my @authors = <felher>;
    my $expected-output = 1074;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob018";

subtest {
    plan 1;

    my $problem = "prob019";
    my @authors = <grondilu>;
    my $expected-output = 171;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob019";

subtest {
    plan 1;

    my $problem = "prob020";
    my @authors = <grondilu>;
    my $expected-output = 648;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob020";

subtest {
    plan 1;

    my $problem = "prob021";
    my @authors = <gerdr>;
    my $expected-output = 852810;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob021";

subtest {
    plan 1;

    my $problem = "prob022";
    my @authors = <grondilu>;
    my $expected-output = 871198282;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob022";

subtest {
    plan 1;

    my $problem = "prob023";
    my @authors = <shlomif>;
    my $expected-output = 4179871;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob023";

subtest {
    plan 1;

    my $problem = "prob024";
    my @authors = <moritz>;
    my $expected-output = 2783915460;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob024";

subtest {
    plan 1;

    my $problem = "prob025";
    my @authors = <polettix>;
    my $expected-output = 4782;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob025";

subtest {
    plan 1;

    my $problem = "prob026";
    my @authors = <shlomif>;
    my $expected-output = "The recurring cycle is 983, and the cycle length is 982";

    check-example-solutions($problem, $expected-output, @authors)
}, "prob026";

skip("prob027-shlomif.pl uses too much memory");
if False {
    subtest {
        plan 1;

        my $problem = "prob027";
        my @authors = <shlomif>;
        my $expected-output = "A sequence of length 71, is generated by a=-61, b=971, the product is -59231";

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob027";
}

subtest {
    plan 1;

    my $problem = "prob028";
    my @authors = <shlomif>;
    my $expected-output = 669171001;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob028";

subtest {
    plan 2;

    my $problem = "prob029";
    my @authors = <gerdr polettix>;
    my $expected-output = 9183;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob029";

subtest {
    plan 1;

    my $problem = "prob031";
    my @authors = <shlomif>;
    my $expected-output = 73682;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob031";

subtest {
    plan 1;

    my $problem = "prob036";
    my @authors = <xenu>;
    my $expected-output = 872187;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob036";

subtest {
    plan 1;

    my $problem = "prob047";
    my @authors = <gerdr>;
    my $expected-output = 134043;

    # build the library required to run this example
    # assume gcc is available
    my $path = "categories/euler";
    qqx{gcc --std=c99 -fPIC -c -o $path/prob047-gerdr.o $path/prob047-gerdr.c};
    qqx{gcc -shared -o $path/prob047-gerdr.so $path/prob047-gerdr.o};

    check-example-solutions($problem, $expected-output, @authors)
}, "prob047";

subtest {
    plan 1;

    my $problem = "prob052";
    my @authors = <duff>;
    my $expected-output = 142857;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob052";

subtest {
    plan 2;

    my $problem = "prob053";
    my @authors = <duff gerdr>;
    my $expected-output = 4075;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob053";

subtest {
    plan 1;

    my $problem = "prob059";
    my @authors = <andreoss>;
    my $expected-output = 107359;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob059";

subtest {
    plan 2;

    my $problem = "prob063";
    my @authors = <moritz polettix>;
    my $expected-output = 49;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob063";

subtest {
    plan 1;

    my $problem = "prob067";
    my @authors = <felher>;
    my $expected-output = 7273;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob067";

subtest {
    plan 1;

    my $problem = "prob081";
    my @authors = <moritz>;
    my $expected-output = 427337;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob081";

skip("prob092-moritz.pl takes too long to run");
if False {
    subtest {
        plan 1;

        my $problem = "prob092";
        my @authors = <moritz>;
        my $expected-output = 8581146;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob092";
}

subtest {
    plan 1;

    my $problem = "prob100";
    my @authors = <andreoss>;
    my $expected-output = 756872327473;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob100";

skip("prob104-moritz.pl takes too long to run");
if False {
    subtest {
        plan 1;

        my $problem = "prob104";
        my @authors = <moritz>;
        my $expected-output = 329468;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob104";
}

skip("prob149-shlomif.pl takes too long to run");
if False {
    subtest {
        plan 1;

        my $problem = "prob149";
        my @authors = <shlomif>;
        my $expected-output = 52852124;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob149";
}

subtest {
    plan 1;

    my $problem = "prob168";
    my @authors = <shlomif>;
    my $expected-output = 59206;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob168";

subtest {
    plan 1;

    my $problem = "prob188";
    my @authors = <shlomif>;
    my $expected-output = 95962097;

    check-example-solutions($problem, $expected-output, @authors)
}, "prob188";

skip("prob189-shlomif.pl takes too long to run");
if False {
    subtest {
        plan 1;

        my $problem = "prob189";
        my @authors = <shlomif>;
        my $expected-output = 10834893628237824;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob189";
}

#| check examples provided by the given authors
sub check-example-solutions($problem, $expected-output, @authors) {
    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }
}

#| run the given example script
sub run-example($name) {
    my $base-dir = "categories/euler";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
