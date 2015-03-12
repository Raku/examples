.PHONY: html test help

html:
	perl6 htmlify.pl

test:
	prove --exec perl6 -r t

help:
	@echo "Usage: make [html|test]"
	@echo ""
	@echo "Options:"
	@echo "   html:             generate the HTML documentation"
	@echo "   test:             run the test suite"
