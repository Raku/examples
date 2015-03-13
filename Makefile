.PHONY: html test help

help:
	@echo "Usage: make [html|test|test-cookbook]"
	@echo ""
	@echo "Options:"
	@echo "   html:             generate the HTML documentation"
	@echo "   test:             run the test suite"
	@echo "   test-sub:         run subdir tests"

html:
	perl6 htmlify.pl

test:
	prove --exec perl6 -r t

test-sub:
	@if test -d "categories/cookbook/t" ; then \
	  prove --exec perl6 -r categories/cookbook/t ; \
	else \
	  echo "No test subdir found." ; \
	fi

