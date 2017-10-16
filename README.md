# Perl 6 Examples

[![Build Status](https://travis-ci.org/perl6/perl6-examples.svg?branch=master)](https://travis-ci.org/perl6/perl6-examples)

This is intended to be a repository for all kinds of Perl 6 examples.

All examples should work for any full implementation of Perl 6.

If an example needs an implementation specific version then it should end in
.implementation.  For example, if you are making an example that only works
on Rakudo, it should end in .rakudo.

If you want to contribute, just ask! The quicker choice is to use IRC:
[join `#perl6` on `irc.freenode.net`](https://docs.perl6.org/webchat.html)
and you'll be welcome.

Please use POD (mostly this template
https://github.com/perl6/perl6-examples/blob/master/doc/example-template.pl) when
adding a new example.

## Goals

1. Compile a list of open source Perl 6 examples
2. Help different implementations of Perl 6 test out their code in a less
   testy and more fun manner `;)`

## What you can find here

| Directory          | Description                              |
|--------------------|------------------------------------------|
|categories          | All example categories |
|bin                 | Utility scripts |
|lib                 | Utility modules |
|doc                 | Out-of-script documentation |

### Categories

| Directory          | Description |
|--------------------|-------------|
|best-of-rosettacode | The best of the rosettacode.org examples |
|99-problems         | Based on lisp 99 problems |
|cookbook            | Cookbook examples |
|euler               | [Answers for Project Euler](http://projecteuler.net) |
|games               | Games should go in here :) |
|interpreters        | Language or DSL interpreters |
|module-management   | Module management |
|other               | All other examples |
|parsers             | Example grammars |
|perlmonks           | Answers to perlmonks.org questions |
|rosalind            | Bioinformatics programming problems |
|shootout            | [The Computer Language Benchmark Game](http://shootout.alioth.debian.org/) |
|tutorial            | Tutorial examples |
|wsg                 | Answers for Winter Scripting Games |

Since you have a commit-bit (if not then talk to the folks at #perl6 on
irc.freenode.net) feel free to commit your changes to the main repository.
No need to submit a pull request!

## Dependencies

To run all examples and tests, a number of modules need to be installed.

These are listed in `META6.json`.

They can be installed via [`zef`](https://modules.perl6.org/dist/zef):

    $ zef --depsonly install .

## Running the examples

To run most examples (all examples excluding those which take a very long
time or are memory hogs) one can use the `run-examples.pl` script in the
`bin` directory:

    $ perl6 bin/run-examples.pl

or simply via the `run-all` target of the Makefle:

    $ make run-all

If one wishes to run the examples for a given category, then one can simply
use the `--category=<category-dir>` option specifying the desired category's
directory name.  For example, to run the examples for the `cookbook`
category, use the following:

    $ perl6 bin/run-examples.pl --category=cookbook

## Building the examples documentation

To build the examples documentation web pages, simply run

    $ make html

or you can run the `htmlify.p6` script in the base directory:

    $ perl6 htmlify.p6

After the pages have been generated, you can view them on your local
computer by starting the included `app.pl` program:

    $ perl app.pl daemon

You can then view the examples documentation by pointing your web browser at
http://localhost:3000.

## License Information

"Perl 6 Examples" is free software; you can redistribute it and/or modify it
under the terms of the Artistic License 2.0.  (Note that, unlike the
Artistic License 1.0, version 2.0 is GPL compatible by itself, hence there
is no benefit to having an Artistic 2.0 / GPL disjunction.)  See the file
LICENSE for details.
