.PHONY: html run-all test help

EXAMPLES_DEPS = \
		URI \
		Pod::To::HTML \
		LWP::Simple \
		Algorithm::Soundex \
		DBIish \
		File::Temp \
		Text::VimColour \
		HTTP::Easy \
		Term::ANSIColor \
		Term::termios

#		Web::Request \

help:
	@echo "Usage: make <option>"
	@echo ""
	@echo "Options:"
	@echo "   html               generate the HTML documentation"
	@echo "   html-nohighlight   generate HTML without syntax highlighting"
	@echo "   run-all            run all examples"
	@echo "   test               test the supporting software"
	@echo "   web-server         display HTML on localhost:3000"
	@echo "   install-deps       install dependencies required for examples"

html: install-deps
	@echo "*** Generating HTML pages ***"
	perl6 htmlify.pl

html-nohighlight: install-deps
	@echo "*** Generating HTML pages (without syntax highlighting) ***"
	perl6 htmlify.pl --no-highlight

run-all: install-deps
	perl6 bin/run-examples.pl

web-server:
	perl app.pl daemon

test: install-deps
	prove --exec perl6 -r t

install-deps:
	@echo "*** Installing dependencies ***"
	for dep in $(EXAMPLES_DEPS);\
	do\
	    perl6 -e "use $$dep" 2> /dev/null;\
	    if [ $$? != 0 ];\
	    then\
		panda --notests install $$dep;\
	    fi;\
	done
