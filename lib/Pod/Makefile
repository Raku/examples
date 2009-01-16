# Makefile for the Pod utilities Pod::Parser and Pod::to::whatever

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
# IRC server irc.freenode.net and join the #perl6 channel, or see below.
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

# Bugs:
# These Pod tools may give errors running with certain revisions of
# Rakudo. Rakudo and the Pod tools are undergoing rapid development.
# The most recent successfully tested Rakudo revision is Parrot r35300.
# If you have problems with a later revision of Rakudo, try bisecting:
#     make PARROT_REV=35300 testrev              # or make testrev
# 35309 good 35568 Lexical 'self' not found 

# RT#62376 notes that perl6 --target=pir fails and parrot perl6.pbc
# --target=pir works. This Makefile has switched to the latter.

# Configuration variables:
# override one or more of these to adapt to local parrot and perl6-examples directories
# eg: make PARROT_DIR=/stuff/my/parrot test
PARROT_DIR   = ../../../parrot
PARROT       = $(PARROT_DIR)/parrot
PERL6_DIR    = $(PARROT_DIR)/languages/perl6
# in Parrot 1.0 PERL6_DIR will be outside of PARROT_DIR (fly the nest).
PERL6_PBC    = $(PERL6_DIR)/perl6.pbc
#PERL6       = $(PERL6_DIR)/perl6     # causes segfaults
PERL6        = $(PARROT) $(PERL6_PBC)
PARROT_REV   = HEAD
EXAMPLES_DIR = ../..
EXAMPLES_BIN = $(EXAMPLES_DIR)/bin
PERL6LIB     = ..

all: precompile

precompile: Parser.pir to/text.pir to/man.pir\
 $(PERL6LIB)/Test.pir $(PERL6LIB)/Test/Harness.pir

# define how to precompile a module from its source code
.SUFFIXES: .pm .pir
.pm.pir: $(PARROT)
	@echo 'precompile $< -> $@'
	@export PERL6LIB=`pwd`/.. ;	$(PERL6) --target=pir --output=$@ $<

# avoid duplication - precompile the Test module from the Parrot source
$(PERL6LIB)/Test.pir: $(PERL6_DIR)/Test.pm $(PARROT)
	@echo 'precompile $(PERL6_DIR)/Test.pm -> $(PERL6LIB)/Test.pir'
	@$(PERL6) --target=pir --output=$(PERL6LIB)/Test.pir $(PERL6_DIR)/Test.pm

test: all $(PARROT)
	@echo 'prove --perl="$(PERL6)" --recurse t'
	@export PERL6LIB=$(PERL6LIB); $(PERL6) $(EXAMPLES_BIN)/prove --perl='$(PERL6)' --recurse t

testrev:
	rm -rf /tmp/parrot
	svn checkout --revision $(PARROT_REV) https://svn.perl.org/parrot/trunk /tmp/parrot
	cd /tmp/parrot; perl Makefile.PL
	$(MAKE) --silent -C /tmp/parrot
	$(MAKE) --silent -C /tmp/parrot perl6
	$(MAKE) --silent clean
	$(MAKE) --silent precompile
	$(MAKE) --silent PARROT_DIR=/tmp/parrot test
	@echo 'Parrot/Rakudo r$(PARROT_REV)'

clean:
	@find . -name '*.pir'             -exec rm {} ';' # Parser.pir etc
	@find .. -name 'Test.pir'         -exec rm {} ';'
	@find ../Test -name 'Harness.pir' -exec rm {} ';'
	@find ../.. -name '*~'            -exec rm {} ';' # editor backups

# List the targets to be made by users
help:
	@echo ''
	@echo 'You can make the following targets:'
	@echo ''
	@echo 'help    - this list. See also: head --lines=67 Makefile'
	@echo 'all     - compiles .pm files to .pir for faster loading'
	@echo 'test    - runs prove on the t/*.t scripts'
	@echo 'testrev - build and test PARROT_REV=nnnnn in /tmp/parrot'
	@echo 'clean   - removes .pir and editor backup files'
	@echo ''
	@echo 'PARROT_DIR: default ../../../parrot'
	@echo 'Example: make PARROT_DIR=/other/parrot test'
	@echo ''
	@echo 'PARROT_REV: default HEAD'
	@echo 'Example: make PARROT_REV=35300 testrev     # or make testrev'
	@echo ''

