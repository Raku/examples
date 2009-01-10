# Makefile for Pod::Parser and Pod::to::whatever

# Default paths assume that parrot/ and perl6-examples/ are in the same
# parent directory. See Configuration variables below to override.

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
# make spectest
# alias perl6=`pwd`/perl6 # or # sudo ln -s `pwd`/perl6 /usr/local/bin
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
# cd parrot
# svn up
# cd ../perl6-examples
# git pull

# Later still, if you are a contributor (see perl6-examples/README)
# and you have edited files, do:
# cd ../perl6-examples
# git diff
# git commit -a
# git push

# The above is minimal. See svn --help and git --help for more options.

# Configuration variables:
# override one or more of these to adapt to local parrot and perl6-examples directories
# eg: make PARROT_DIR=/stuff/my/parrot test
PARROT_DIR   = ../../../parrot
RAKUDO_DIR   = $(PARROT_DIR)/languages/perl6
RAKUDO_EXE   = $(RAKUDO_DIR)/perl6
PERL6BIN     = ../../bin
PERL6LIB     = ..
# RAKUDO_DIR should become independent of PARROT_DIR when Parrot 1.0 is out.

# define how to precompile a module from its source code
.SUFFIXES: .pm .pir
.pm.pir: $(RAKUDO_EXE)
#	PERL6LIB=`pwd`/.. $(RAKUDO_EXE) --target=pir --output=$@ $<
	$(RAKUDO_EXE) --target=pir --output=$@ $<

pod-modules-precompiled: Parser.pir to/text.pir to/man.pir\
 $(PERL6LIB)/Test.pir $(PERL6LIB)/Test/Harness.pir

# avoid duplication - precompile the Test module from the Parrot source
$(PERL6LIB)/Test.pir: $(RAKUDO_DIR)/Test.pm $(RAKUDO_EXE)
	$(RAKUDO_EXE) --target=pir --output=$(PERL6LIB)/Test.pir $(RAKUDO_DIR)/Test.pm

all: pod-modules-precompiled

test: all $(RAKUDO_EXE)
	$(PERL6BIN)/prove --recurse t

clean:
	@find . -name '*.pir'             -exec rm {} ';' # Parser.pir etc
	@find .. -name 'Test.pir'         -exec rm {} ';'
	@find ../Test -name 'Harness.pir' -exec rm {} ';'
	@find . -name '*~'                -exec rm {} ';' # editor backups

# List the targets to be made by users
help:
	@echo ''
	@echo 'You can make the following targets:'
	@echo ''
	@echo 'help  - this list. See also: head --lines=52 Makefile'
	@echo 'all   - compiles .pm files to .pir for faster loading'
	@echo 'test  - runs prove on the t/*.t scripts'
	@echo 'clean - removes .pir and editor backup files'
	@echo ''

