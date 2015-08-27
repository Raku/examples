.PHONY: html run-all test help

html:
	perl6 htmlify.pl

html-nohighlight:
	perl6 htmlify.pl --no-highlight

run-all:
	perl6 bin/run-examples.pl

web-server:
	perl app.pl daemon

test:
	prove --exec perl6 -r t

help:
	@echo "Usage: make [html|test]"
	@echo ""
	@echo "Options:"
	@echo "   html:              generate the HTML documentation"
	@echo "   html-nohighlight:  generate HTML without syntax highlighting"
	@echo "   run-all:           run all examples"
	@echo "   test:              test the supporting software"
	@echo "   web-server:        display HTML on localhost:3000"
