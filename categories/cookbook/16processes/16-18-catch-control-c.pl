use v6;

=begin pod

=TITLE Catch ctrl-c

=AUTHOR stmuk

Catch ctrl-c to ignore or execute code

=end pod

signal(SIGINT).tap();
#signal(SIGINT).tap( { say "caught" } );
my $name = prompt "what's your name?";
dd $name;
