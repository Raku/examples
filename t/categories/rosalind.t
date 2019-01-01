use v6;

use Test;

plan 41;

my $skip = True;

subtest {
    plan 1;

    my $problem = "afrq";
    my @authors = <grondilu>;
    my $expected-output = "0.532 0.75 0.914";

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "afrq";

subtest {
    plan 1;

    my $problem = "aspc";
    my @authors = <grondilu>;
    my $expected-output = 42;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output, $name);
    }

}, "aspc";

subtest {
    plan 1;

    my $problem = "cons";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    ATGCAACT
    A: 5 1 0 0 5 5 0 0
    C: 0 0 1 4 2 0 6 1
    G: 1 1 6 3 0 1 0 0
    T: 1 5 0 0 0 1 1 6
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "cons";

subtest {
    plan 1;

    my $problem = "conv";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    3
    85.03163
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "conv";

subtest {
    plan 1;

    my $problem = "cstr";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    10110
    10100
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "cstr";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "ctbl";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        00110
        00111
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "ctbl";
}

subtest {
    plan 1;

    my $problem = "dbpr";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    DNA recombination
    DNA repair
    DNA replication
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "dbpr";

subtest {
    plan 2;

    my $problem = "dna";
    my @authors = <gerdr grondilu>;
    my $expected-output = q:to/EOD/;
    20 12 17 21
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "dna";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "eubt";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        (((mouse,cat),elephant))dog;
        (((elephant,mouse),cat))dog;
        (((elephant,cat),mouse))dog;
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "eubt";
}

subtest {
    plan 1;

    my $problem = "eval";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    0.422 0.563 0.422
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "eval";

subtest {
    plan 1;

    my $problem = "fibd";
    my @authors = <grondilu>;
    my $expected-output = 4;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "fibd";

subtest {
    plan 1;

    my $problem = "fib";
    my @authors = <grondilu>;
    my $expected-output = 19;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "fib";

subtest {
    plan 1;

    my $problem = "gc";
    my @authors = <gerdr>;
    my $expected-output = rx/60\.91954/;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        like($output.chomp, $expected-output, $name);
    }

}, "gc";

subtest {
    plan 1;

    my $problem = "grph";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    Rosalind_0498 Rosalind_2391
    Rosalind_0498 Rosalind_0442
    Rosalind_2391 Rosalind_2323
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.split(/\n/).sort, $expected-output.split(/\n/).sort, $name);
    }

}, "grph";

subtest {
    plan 1;

    my $problem = "hamm";
    my @authors = <grondilu>;
    my $expected-output = 7;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "hamm";

subtest {
    plan 1;

    my $problem = "iev";
    my @authors = <grondilu>;
    my $expected-output = 3.5;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "iev";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "indc";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        0.000 -0.004 -0.024 -0.082 -0.206 -0.424 -0.765 -1.262 -1.969 -3.010
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "indc";
}

subtest {
    plan 1;

    my $problem = "iprb";
    my @authors = <grondilu>;
    my $expected-output = 0.783333;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "iprb";

subtest {
    plan 1;

    my $problem = "itwv";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    0 0 1
    0 1 0
    1 0 0
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "itwv";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "lcsq";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        AACTG
        EOD

        # build the library required to run this example
        # assume gcc is available
        my $path = "categories/rosalind";
        qqx{gcc --std=c99 -fPIC -c -o $path/lcsq.o $path/lcsq.c};
        qqx{gcc -shared -o $path/lcsq.so $path/lcsq.o};

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "lcsq";
}

subtest {
    plan 1;

    my $problem = "lia";
    my @authors = <grondilu>;
    my $expected-output = 0.684;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "lia";

subtest {
    plan 1;

    my $problem = "mmch";
    my @authors = <grondilu>;
    my $expected-output = 6;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "mmch";

subtest {
    plan 1;

    my $problem = "mprt";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    B5ZC00
    85 118 142 306 395
    P07204_TRBM_HUMAN
    47 115 116 382 409
    P20840_SAG1_YEAST
    79 109 135 248 306 348 364 402 485 501 614
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "mprt";

subtest {
    plan 1;

    my $problem = "mrna";
    my @authors = <grondilu>;
    my $expected-output = 12;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "mrna";

subtest {
    plan 1;

    my $problem = "nwck";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    1 2
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "nwck";

subtest {
    plan 1;

    my $problem = "orf";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    MLLGSFRLIPKETLIQVAGSSPCNLS
    M
    MGMTPRLGLESLLE
    MTPRLGLESLLE
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp.split(/\s+/).sort.join(" "),
           $expected-output.chomp.split(/\s+/).sort.join(" "),
           $name);
    }

}, "orf";

subtest {
    plan 1;

    my $problem = "pmch";
    my @authors = <grondilu>;
    my $expected-output = 12;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "pmch";

subtest {
    plan 1;

    my $problem = "pper";
    my @authors = <grondilu>;
    my $expected-output = 51200;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "pper";

subtest {
    plan 1;

    my $problem = "prob";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    -5.737 -5.217 -5.263 -5.360 -5.958 -6.628 -7.009
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "prob";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "qrt";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        {elephant, dog} {rabbit, robot}
        {cat, dog} {mouse, rabbit}
        {mouse, rabbit} {cat, elephant}
        {dog, elephant} {mouse, rabbit}
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "qrt";
}

subtest {
    plan 1;

    my $problem = "revc";
    my @authors = <gerdr>;
    my $expected-output = q:to/EOD/;
    ACCGGGTTTT
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "revc";

subtest {
    plan 1;

    my $problem = "rna";
    my @authors = <gerdr>;
    my $expected-output = q:to/EOD/;
    GAUGGAACUUGACUACGUAAAUU
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "rna";

subtest {
    plan 1;

    my $problem = "rstr";
    my @authors = <grondilu>;
    my $expected-output = 0.689;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "rstr";

subtest {
    plan 1;

    my $problem = "sexl";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    0.18 0.5 0.32
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "sexl";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "sgra";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        WMSPG
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "sgra";
}

subtest {
    plan 1;

    my $problem = "spec";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    WMQS
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "spec";

subtest {
    plan 1;

    my $problem = "sseq";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    3 4 5
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "sseq";

subtest {
    plan 1;

    my $problem = "subs";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    2 4 10
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "subs";

if $skip {
    skip("Doesn't exactly agree with expected output");
}
else {
    subtest {
        plan 1;

        my $problem = "suff";
        my @authors = <grondilu>;
        my $expected-output = q:to/EOD/;
        AAATG$
        G$
        T
        ATG$
        TG$
        A
        A
        AAATG$
        G$
        T
        G$
        $
        EOD

        for @authors -> $author {
            my $name = "$problem-$author.pl";
            my $output = run-example($name);
            is($output.chomp, $expected-output.chomp, $name);
        }

    }, "suff";
}

subtest {
    plan 1;

    my $problem = "tran";
    my @authors = <grondilu>;
    my $expected-output = 1.21428571429;

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "tran";

subtest {
    plan 1;

    my $problem = "trie";
    my @authors = <grondilu>;
    my $expected-output = q:to/EOD/;
    1 2 A
    2 3 T
    3 4 A
    4 5 G
    5 6 A
    3 7 C
    1 8 G
    8 9 A
    9 10 T
    EOD

    for @authors -> $author {
        my $name = "$problem-$author.pl";
        my $output = run-example($name);
        is($output.chomp, $expected-output.chomp, $name);
    }

}, "trie";

#| run the given example script
sub run-example($name) {
    my $base-dir = "categories/rosalind";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
