use v6;

use Test;

plan 9;

my $skip = True;

subtest {
    plan 1;

    my $example-name = "01-00introduction.p6";
    my $expected-output = q:to/EOD/;
Hello
Hello
Hello
Hello World!
Hello World!
Hello World!
This is $string: a scalar holding a String
$string is Str
This is $scalar holding a String
$scalar is Str
1
2 is a number interpreted as a string
7 is a number interpreted as a string
0
2
111
1 + 1
2
1234
$scalar is Int
~$scalar is Str
    The quick brown fox jumps over the lazy dog.
	dog.
    The quick brown fox jumps over the lazy
	dog.
The quick brown fox\n\tjumps over the lazy dog\n
The quick brown fox
	jumps over the lazy dog

The quick brown fox jumps over the lazy $var1
The quick brown fox jumps over the lazy dog
The quick brown @animal[0] jumps over the lazy @animal[1]
The quick brown fox jumps over the lazy dog
The quick brown %animal{'quick'} jumps over the lazy %animal{'lazy'}.
The quick brown fox jumps over the lazy dog.
@animal.elems() {@animal.elems} &elems(@animal)
2 2 2
EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-00introduction.p6";

subtest {
    plan 1;

    my $example-name = "01-01substrings.p6";
    my $expected-output = q:to/EOD/;
    kudo is
    kudo is da bomb
    Radiators are nice in winter
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-01substrings.p6";

subtest {
    plan 1;

    my $example-name = "01-03exchanging-values.p6";
    my $expected-output = q:to/EOD/;
    2
    3
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-03exchanging-values.p6";

subtest {
    plan 1;

    my $example-name = "01-04converting-values.p6";
    my $expected-output = q:to/EOD/;
97
a
© : 169 : ©
foo : 102 111 111
EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-04converting-values.p6";

subtest {
    plan 1;

    my $example-name = "01-05namedunicode.p6";
    my $expected-output = q:to/EOD/;
    ®
    😾
    POUTING CAT FACE
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-05namedunicode.p6";

subtest {
    plan 1;

    my $example-name = "01-07reversing-strings.p6";
    my $expected-output = q:to/EOD/;
    egarfissO hsimaeuqS era sdroW cigaM ehT
    Ossifrage Squeamish are Words Magic The
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-07reversing-strings.p6";

subtest {
    plan 1;

    my $example-name = "01-13upper-lower-case.p6";
    my $expected-output = q:to/EOD/;
    THE CAT SAT ON THE MAT
    the cat sat on the mat
    The Cat Sat On The Mat
    The cat sat on the mat
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-13upper-lower-case.pl";

subtest {
    plan 1;

    my $example-name = "01-19trim-whitespace.p6";
    my $expected-output = q:to/EOD/;
    :string("the cat sat on the mat")
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-19trim-whitespace.p6";

subtest {
    plan 1;

    my $example-name = "01-22soundex-matching.p6";
    my $expected-output = q:to/EOD/;
    S530
    S530
    B420
    EOD

    my $output = run-example($example-name);
    is($output, $expected-output, $example-name);
}, "01-22soundex-matching.p6";

#| run the given example script
sub run-example($name, :$script-args = Nil) {
    my $base-dir = "categories/cookbook/01strings";
    my $script-path = $base-dir ~ "/" ~ $name;
    my $base-cmd = "perl6 $script-path";
    my $output = $script-args ?? qqx{$base-cmd \"$script-args\"}
                              !! qqx{$base-cmd};

    return $output;
}

# vim: expandtab shiftwidth=4 ft=perl6
