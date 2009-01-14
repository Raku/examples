# Makefile for HTTP::Daemon
#
# Synopsis:
#   make help                           # target summary
#   make all                            # precompile to Daemon.pir
#   make run                            # start httpd + HTTP::Daemon
#   make PARROT_DIR=/other/parrot all   # precompile with other parrot
#   make PARROT_DIR=/other/parrot run   # run with other parrot
#
# Bugs:
# This code may fail with certain revisions of Parrot and Rakudo.
# All this software is being rapidly developed and frequently updated.
# Use IRC on irc.freenode.net and join the #perl6 channel for news/help.
#

all: precompile

precompile: Daemon.pir

clean:
	@find . -name '*.pir' -exec rm {} ';' # precompiled modules
	@find . -name '*~'    -exec rm {} ';' # editor backups

run:
	@# $(RAKUDO_EXE) being ../ based usually goes wrong when you cd.
	@# Fortunately `pwd` always outputs an absolute path. Note the
	@# difference between $(VAR) make variables and $VAR shell variables.
	@DAEMON_DIR=`pwd`                                     ;\
	cd $(RAKUDO_DIR)                                      ;\
	export RAKUDO_DIR=`pwd`                               ;\
	cd $$DAEMON_DIR/..                                    ;\
	export PERL6LIB=`pwd`                                 ;\
	cd ../bin                                             ;\
	$$RAKUDO_DIR/perl6 httpd                           #  ^ these ;\ are
	@# to make this a single logical command line spread over several
	@# physical lines. The make utility executes each logical command
	@# line in a separate child shell. The multiple commands must be
	@# combined this way to share the _DIR and PERL6LIB variables.

test:
	svn update --revision $(PARROT_REV) $(PARROT_DIR)
	cd $(PARROT_DIR) ;\
	make realclean   ;\
	perl Makefile.PL ;\
	make             ;\
	make perl6

# Configuration variables:
# Override one or more of these on the command line to adapt to local
# parrot, rakudo and perl6-examples directories. Note these are make
# variables, not shell variables.
#     eg: make PARROT_DIR=/my/parrot run
PARROT_DIR = ../../../parrot
RAKUDO_DIR = $(PARROT_DIR)/languages/perl6
RAKUDO_EXE = $(RAKUDO_DIR)/perl6
PARROT_REV = HEAD
PERL6BIN   = ../../bin
PERL6LIB   = ..

# define how to precompile a module from its source code
.SUFFIXES: .pm .pir
.pm.pir: $(RAKUDO_EXE)
	$(RAKUDO_EXE) --target=pir --output=$@ $<

# List the targets to be made by users
help:
	@echo ''
	@echo 'You can make the following targets:'
	@echo ''
	@echo 'all   - [default] precompile .pm to .pir for faster loading'
	@echo 'clean - removes .pir and editor backup files'
	@echo 'run   - runs the httpd web server with or without precompile'
	@echo 'help  - this text. See also: head --lines=14 Makefile'
	@echo ''
	@echo 'The default perl6 is from within the ../../../parrot directory.'
	@echo 'Override with for example: make PARROT_DIR=/other/parrot run'
	@echo ''

