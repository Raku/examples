# NOTE

This repo is being archived and the site will no longer be available at
http://examples.raku.org.

Look to http://raku.org and http://docs.raku.org

# Raku Examples

[![Build Status](https://travis-ci.org/raku/examples.svg?branch=master)](https://travis-ci.org/raku/examples)

This is intended to be a repository for all kinds of Raku examples.

All examples should work on a recent compiler release of Rakudo.

If you want to contribute, just ask! The quicker choice is to use IRC:
[join `#raku` on `irc.libera.chat`](https://kiwiirc.com/nextclient/irc.libera.chat/#raku)
and you'll be welcome.


Please use POD6 when adding a new example. [This
template](https://github.com/raku/examples/blob/master/doc/example-template.pl)
can help get you started.

## Goals

1. Compile a list of open source Raku examples
2. Help different implementations of Raku test out their code in a less
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
|rosalind            | Bioinformatics programming problems |
|shootout            | [The Computer Language Benchmark Game](http://shootout.alioth.debian.org/) |
|tutorial            | Tutorial examples |
|wsg                 | Answers for Winter Scripting Games |

## Dependencies

To run all examples and tests, a number of modules need to be installed.

These are listed in `META6.json`.

They can be installed via [`zef`](https://modules.raku.org/dist/zef):

    $ zef --deps-only install .

## Running the examples

To run most examples (all examples excluding those which take a very long
time or are memory hogs) one can use the `run-examples.pl` script in the
`bin` directory:

    $ raku bin/run-examples.pl

or simply via the `run-all` target of the Makefle:

    $ make run-all

If one wishes to run the examples for a given category, then one can simply
use the `--category=<category-dir>` option specifying the desired category's
directory name.  For example, to run the examples for the `cookbook`
category, use the following:

    $ raku bin/run-examples.pl --category=cookbook

## Building the examples documentation

To build the examples documentation web pages, simply run

    $ make html

or you can run the `htmlify.pl` script in the base directory:

    $ raku htmlify.pl

After the pages have been generated, you can view them on your local
computer by starting the included `app.pl` program:

    $ raku app.pl daemon

You can then view the examples documentation by pointing your web browser at
http://localhost:3000.

## License Information

"Raku Examples" is free software; you can redistribute it and/or modify it
under the terms of the [Artistic License 2.0](LICENSE).
