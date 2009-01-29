# Makefile for Pod::Parser and Pod::to::whatever utilities

# Try it out (without the leading '# ', with a sensible /my/parrot):
# cd /tmp; rm -rf perl6-examples # (or your dir, eg /usr/masak/junk)
# git clone git://github.com/eric256/perl6-examples.git
# cd /tmp/perl6-examples/lib/Pod;make PARROT_DIR=/my/parrot test
# alias perl6=/my/parrot/languages/perl6/perl6; cd /tmp/perl6-examples/lib
# perl6 ../bin/pod2text  Pod/to/text.pm
# perl6 ../bin/perldoc   Pod/to/man.pm
# perl6 ../bin/pod2xhtml Pod/to/xhtml.pm

# If you want to keep a more permanent perl6-examples tree, the default
# paths in this Makefile assumes that parrot/ and perl6-examples/ use the
# same base directory. Some people (they do not need to be named) have
# odd directory layouts, and those are accommodated with the PARROT_DIR
# option to the make command, described in Configuration variables: below.

# Chat with the author (and other helpful people) on irc.freenode.net in
# the #perl6 channel.

# To install git on Debian, Ubuntu and similar systems:
# sudo apt-get --yes install git-core

# To bring your perl6-examples up to date from the github repository:
# cd perl6-examples     # from your base directory
# git pull

# To send your improvements to the repository, become a contributor
# (see perl6-examples/README) and then do:
# cd perl6-examples     # from your base directory
# git diff              # to review what you have changed
# git commit -a         # or git add <specific files>
# git push

# The above is minimal. See svn --help and git --help for more options.

# Configuration variables:
# Some people keep several parrots or just one in a special place.
# Replace /my/parrot if it is not perl6-examples/../parrot:
#   make PARROT_DIR=/stuff/my/parrot test

# Bugs:
# These Pod tools may give errors running with certain revisions of
# Rakudo. Rakudo and the Pod tools are undergoing rapid development.
# The most recent successfully tested Rakudo revision is Parrot r36134.
# If some revision of Rakudo seems faulty, try to bisect revisions:
#   make PARROT_REV=36134 testrev            # full /tmp/parrot checkout
#   make PARROT_REV=36097 PARROT_DIR=/tmp/parrot testrev # parrot update

# Very occasionally either 'perl6' or 'parrot perl6.pbc' segfault,
# try the other PERL6 definition for a temporary alternative.

PARROT_DIR   = ../../../parrot
PARROT       = $(PARROT_DIR)/parrot
PERL6_DIR    = $(PARROT_DIR)/languages/perl6
# in Parrot 1.0 PERL6_DIR will be outside of PARROT_DIR (fly the nest).
PERL6_PBC    = $(PERL6_DIR)/perl6.pbc
PERL6        = $(PERL6_DIR)/perl6     # may cause occasional segfaults
#PERL6       = $(PARROT) $(PERL6_PBC) # may cause occasional segfaults
PARROT_REV   = HEAD
EXAMPLES_DIR = ../..
EXAMPLES_BIN = $(EXAMPLES_DIR)/bin
PERL6LIB     = ..

all: precompile

precompile: Parser.pir to/text.pir to/man.pir to/xhtml.pir to/pod5.pir \
 to/pod6.pir \
 $(PERL6LIB)/Test.pir $(PERL6LIB)/Test/Harness.pir \
 $(PERL6LIB)/Test/Differences.pir

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

# in 'make PARROT_DIR=/path/to/parrot PARROT_REV=12345 test' the default
# or overridden values interact as follows:
#   PARROT_DIR   PARROT_REV   action
#   omitted      omitted      use whatever parrot you have in ../../..
#   omitted      set          do svn update --revision nnnnn, then test
#   set          omitted      uses whatever parrot you have in /set/
#   set          set          does svn checkout --revision nnnnn in /set/
ifeq "$(PARROT_DIR)" "../../../parrot"
PARROT_TMP_DIR=/tmp/parrot
else
PARROT_TMP_DIR=$(PARROT_DIR)
endif
testrev:
ifeq "$(PARROT_DIR)" "$(PARROT_TMP_DIR)"
	@echo "You specified $(PARROT_TMP_DIR), so svn update there (faster)"
	time svn update --revision $(PARROT_REV) $(PARROT_TMP_DIR)
else
	@echo "You did not specify PARROT_DIR, so make a new default /tmp/parrot (slower)"
	rm -rf /tmp/parrot
	time svn checkout --revision $(PARROT_REV) https://svn.perl.org/parrot/trunk /tmp/parrot
endif
	cd $(PARROT_TMP_DIR); perl Makefile.PL
	$(MAKE) --no-print-directory -C $(PARROT_TMP_DIR)
	$(MAKE) --no-print-directory -C $(PARROT_TMP_DIR) perl6
	@$(PARROT_TMP_DIR)/languages/perl6/perl6 -e 'say "Parrot/Rakudo r{%*VM<config><revision>}"'
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory PARROT_DIR=$(PARROT_TMP_DIR) precompile
	$(MAKE)  --no-print-directory PARROT_DIR=$(PARROT_TMP_DIR) test

clean:
	@find .       -name '*.pir'       -exec rm {} ';' # Parser.pir etc
	@find ..      -name 'Test.pir'    -exec rm {} ';'
	@find ../Test -name 'Harness.pir' -exec rm {} ';'
	@find ../Test -name 'Differences.pir' -exec rm {} ';'
	@find ../..   -name '*~'          -exec rm {} ';' # editor backups

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
	@echo 'PARROT_DIR: default=../../../parrot'
	@echo 'Example: make PARROT_DIR=/other/parrot test'
	@echo ''
	@echo 'PARROT_REV: default=HEAD'
	@echo 'Example: make PARROT_REV=35309 testrev     # or make testrev'
	@echo ''

