# Makefile for the Pod utilities Pod::Parser and Pod::to::whatever
#
# Try it out: copy and execute the following without the leading '# '
# cd /tmp; rm -rf parrot perl6-examples # (or your dir, eg /usr/masak/junk)
# git clone git://github.com/eric256/perl6-examples.git
# svn checkout --revision 35309 http://svn.perl.org/parrot/trunk parrot
# #                       ^^^^^ (your sys latest good rev in Parser.pm)
# cd /tmp/parrot;perl Makefile.PL;make;make perl6;cd /tmp
# cd /tmp/perl6-examples/lib/Pod;make PARROT_DIR=/tmp/parrot test
# # Or 'make PARROT_REV=HEAD PARROT_DIR=/tmp/parrot testrev' # new bugs.
#
# Default paths assume that parrot/ and perl6-examples/ are in the same
# parent directory. Override with Configuration variables: below.

# Getting started: execute commands below without the initial # sign,
# or edit them first into a shell script.
# The following assumes a freshly installed Linux system such as Ubuntu.
# If your system is already being used, skip commands you don't need.
# Bugs appear in the source code occasionally ;) , for help connect to
# irc.freenode.net and join the #perl6 channel, or read on...
#
# # if svn does not work (in Debian, Ubuntu and similar systems):
# sudo apt-get --yes install subversion
## # if git does not work (in Debian, Ubuntu and similar systems):
# sudo apt-get --yes install git-core
#
# Later, if you still have /tmp/parrot and /tmp/perl6-examples and other
# people have updated the repositories, do:
# cd /tmp/parrot;svn up;make realclean;perl Makefile.PL;make;make perl6
# cd /tmp/perl6-examples;git pull;

# Later still, if you improve ments (see perl6-examples/README) and
# you have files, do:
# cd /tmp/perl6-examples
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
# Bisect results of 'make PARROT_REV=nnnnn testrev':
# Debian x86-32 35300 good
# Debian x86-64 35309 good
#               35311 t/01-parser.t....Null PMC access in get_string() current instr.: 'infix:ne'

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

precompile: Parser.pir to/text.pir to/man.pir to/xhtml.pir to/pod5.pir \
 to/pod6.pir \
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

# in 'make PARROT_DIR=/path/to/parrot PARROT_REV=12345 test' the default
# or overridden values interact as follows:
#   PARROT_DIR   PARROT_REV   action
#   omitted      omitted      uses whatever parrot you have under ../../..
#   omitted      set          does svn update --revision nnnnn, then test
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

