#!/usr/bin/perl

# perl5 utility script to add collaborators to the github repo

use strict;
use warnings;

use WWW::Mechanize;


my $login = "https://github.com/login";

my ($username, $password, $repo, $newuser) = (shift, shift, shift, shift);
my $url = "https://github.com/$username/$repo/edit/add_member?member=$newuser";

my $mech = WWW::Mechanize->new();

$mech->get($login);
$mech->submit_form(
   form_number => 1,
   fields => { login=>$username, password=>$password }
);

$mech->get($url);

