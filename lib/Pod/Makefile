# Makefile for Pod::Parser and Pod::to::whatever

# All paths in here assume that parrot/ and perl6-examples/ are in the
# same parent directory.

# Getting started: execute commands below without the initial # sign,
# or edit them first into a shell script.
# The following assumes a freshly installed Linux system such as Ubuntu.
# If your system is already being used, skip commands you don't need.
# The 'time' option in these lines is, er, optional.
# You may also skip lines containing any form of 'test' to save time,
# but tests are valuable to confirm that the software is working.
# Bugs appear in the source code occasionally, for help connect to the
# IRC server irc.freenode.net and join the #perl6 channel.
#
# sudo apt-get update
# sudo apt-get --yes install subversion
# time svn checkout https://svn.perl.org/parrot/trunk parrot
# cd parrot
# perl Makefile.PL
# time make
# make test
# cd languages/perl6
# time make perl6
# make test
# make spectest_regression
# cd
# sudo apt-get --yes install git-core
# git clone git://github.com/eric256/perl6-examples.git
# PATH=$PATH:`pwd`/perl6-examples/bin
# export PERL6LIB=`pwd`/perl6-examples/lib
# cd perl6-examples/lib/Pod
# make
# make help
# make test

# Later, when new code has appeared in parrot or perl6-examples, do:
# svn up ~/parrot
# git pull ~/perl6-examples

# Later still, if you are a contributor (see perl6-examples/README)
# and you have edited files, do:
# git diff
# git commit -a
# git push ~/perl6-examples

# The above is minimal. See svn --help and git --help for more options.

PERL6 = /usr/local/bin/perl6

# define how to precompile a module from its source code
.SUFFIXES: .pm .pir
.pm.pir: $(PERL6)
	PERL6LIB=`pwd`/.. $(PERL6) --target=pir --output=$@ $<

pod-modules-precompiled: Parser.pir to/text.pir to/man.pir

# avoid duplication - precompile the Test module from the Parrot source
../Test.pir: ../../../parrot/languages/perl6/Test.pm $(PERL6)
	perl6 --target=pir --output=../Test.pir ../../../parrot/languages/perl6/Test.pm

all: pod-modules-precompiled ../Test.pir

test: pod-modules-precompiled ../Test/Harness.pir ../Test.pir
	PERL6LIB=.. ../../bin/prove --recurse t

clean:
	@find . -name '*.pir'       -exec rm {} ';' # precompiled modules
	@find . -name '*~'          -exec rm {} ';' # edit backup files

# List the targets to be made by users
help:
	@echo ''
	@echo 'You can make the following targets:'
	@echo ''
	@echo 'help  - this list. See also: head --lines=48 Makefile'
	@echo 'all   - compiles .pm files to .pir for faster loading'
	@echo 'test  - runs prove on the t/*.t scripts'
	@echo 'clean - removes .pir and editor backup files'
	@echo ''

