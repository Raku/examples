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
	raku -Ilib htmlify.p6

html-nohighlight:
	@echo "*** Generating HTML pages (without syntax highlighting) ***"
	raku -Ilib htmlify.p6 --no-highlight

run-all:
	raku bin/run-examples.raku

web-server:
	cro run .

test:
	prove --exec raku -r t

install-deps:
	@echo "*** Installing dependencies ***"
	zef --/test --test-depends --depsonly install .
