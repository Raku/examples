.PHONY: html run-all test help

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
	raku htmlify.pl

html-nohighlight: install-deps
	@echo "*** Generating HTML pages (without syntax highlighting) ***"
	raku htmlify.pl --no-highlight

run-all: install-deps
	raku bin/run-examples.pl

web-server:
	perl app.pl daemon

test: install-deps
	prove --exec raku -r t

install-deps:
	@echo "*** Installing dependencies ***"
	zef --/test --test-depends --depsonly install .
