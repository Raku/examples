# Project Euler

http://projecteuler.net/

This is a directory to post answers to Project Euler questions.

## Adding a new example solution

Use the file format `prob000-author.pl`, replacing "000" with the problem
number and "author" with your name or your nick.  For example if I am
eric256 and I answer problem No. 1, I will save it as `prob001-eric256.pl`.

Thanks for playing!

### Example solution layout

Please follow the layout of the other example solutions, e.g.:

    use v6;

    =begin pod

    =TITLE Title of example from Project Euler website

    =AUTHOR Your name (or nick, if you want)

    L<https://projecteuler.net/problem=XXX> # where XXX is the problem number

    Description of the problem as per the Project Euler website

    Expected result:  XXXX   # the expected output

    =end pod

    # perl6 code solving the given problem

### Add a test for your example solution

The solutions are tested in `t/categories/euler.t`.  If you add a solution
to an as yet unsolved problem, add a new subtest like so:

    subtest {
        plan 1;

        my $problem = "probXXX";
        my @authors = <your-nick>;
        my $expected-output = XXXXX;

        check-example-solutions($problem, $expected-output, @authors)
    }, "probXXX";

Don't forget to increment the plan for all tests!

Or if you add a new, alternative solution to a previously solved problem,
merely add your name/nick to the list of authors for that problem and
increment the plan for that subtest, e.g.:

    subtest {
        plan 6;  # bumped from 5 to 6

        my $problem = "prob001";
        # "your-nick" added to list of authors
        my @authors = <cspencer eric256 grondilu hexmode unobe your-nick>;
        my $expected-output = 233168;

        check-example-solutions($problem, $expected-output, @authors)
    }, "prob001";
