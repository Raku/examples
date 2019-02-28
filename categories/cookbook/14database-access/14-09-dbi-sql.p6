#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Executing SQL with DBIish

=AUTHOR stmuk

Execute some SQL commands using the DBIish database driver

=end pod

use DBIish;

my $dbh = DBIish.connect('SQLite', database => 'video.db');

$dbh.do('DROP TABLE IF EXISTS video');

my $sql =  q:to"END";
CREATE TABLE video(
    id integer primary key not null,
    title text not null,
    uri text not null
)
END

$dbh.do($sql);

my $st = $dbh.prepare('INSERT INTO video(title, uri) VALUES(?, ?)');

# put some data in
$st.execute("Larry Wall - Keynote, APW2014 2014-10-10 ",
            "https://www.youtube.com/watch?v=enlqVqit62Y");
$st.execute("Carl Mäsak - Regexes in Perl 6 - Zero to Perl 6 Training",
            "https://www.youtube.com/watch?v=oo-gA9Z9SaA");

# get some data out
$st = $dbh.prepare('SELECT title,uri FROM video');
$st.execute;

my @rows =  $st.fetchall-AoH;

say @rows.gist;

# vim: expandtab shiftwidth=4 ft=perl6
