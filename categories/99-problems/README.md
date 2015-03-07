# 99  Problems In Perl

Based on the problems from
http://www.ic.unicamp.br/~meidanis/courses/mc336/2006s2/funcional/L-99_Ninety-Nine_Lisp_Problems.html
(which is stored here for future use).

Save solutions as `PXX-author.pl` as in other directories where XX is the problem
number and author is the....author!

Please include a specification describing the problem and, ideally, a
description of your solution and the perl6 features that it uses.

Use this as a template for your solutions:

    use v6;

    # Specification:
    #   PXX (*) Problem copied from L-99_Ninety-Nine_Lisp_Problems.html
    #       You are encouraged to modify the specification to fit perl6 thinking.
    #       For example, P21 originally implied returning a copy of the list,
    #       since LISP does not have mutable lists; you may change the wording to
    #       reflect this, or change the spec to allow modification in-place.
    #
    # Example: (preferably in the form of a REPL session)
    # > say 'Hello, world!'
    # Hello, world!


    # Explanation of your answer, discussion of perl6 features used
    # We create a function which returns its argument to needlessly complicate a
    # hello, world program

    sub my_func ($x) {
	return $x
    }

    say my_func('Hello, world!')
