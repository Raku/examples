.PHONY: html run-all test help

html:
	perl6 htmlify.pl

run-all:
	perl6 bin/run-examples.pl

test:
	prove --exec perl6 -r t

help:
	@echo "Usage: make [html|test]"
	@echo ""
	@echo "Options:"
	@echo "   html:      generate the HTML documentation"
	@echo "   run-all:   run all examples"
	@echo "   test:      test the supporting software"
