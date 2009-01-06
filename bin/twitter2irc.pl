#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;
use Net::Twitter;

use POE;
use POE::Component::IRC::State;
use POE::Component::IRC::Plugin::AutoJoin;

my $delay = 40;
my $connected = 0;
my $user  = 'perl6examples';
my $last_tweet = undef;
my $channel = '#perl6';

POE::Session->create(
     package_states => [
         main => [ qw(_start irc_join check_twitter) ]
     ],
);

sub _start {
     my $heap  = $_[HEAP];
     my $irc = POE::Component::IRC::State->spawn(
         Nick   => 'perl6examples',
         Server => 'irc.freenode.net',
     );
	 $heap->{irc} = $irc;

     $irc->plugin_add('AutoJoin', POE::Component::IRC::Plugin::AutoJoin->new(
        Channels => [ $channel ]
     ));

     $irc->yield(register => 'join');
     $irc->yield(connect => { });
}

sub irc_join {
     my $nick = (split /!/, $_[ARG0])[0];
     my $channel = $_[ARG1];
     my $irc = $_[SENDER]->get_heap();

     # only send the message if we were the one joining
     if ($nick eq $irc->nick_name()) {
	 	$_[KERNEL]->alarm( check_twitter => time() + 5);
	 }
}

sub check_twitter {
    my $heap = $_[HEAP];

    if (!defined $last_tweet) {
		$last_tweet = get_last_tweet($user);
	} else {
		my $tweets = get_tweets_since($user, $last_tweet);
		for my $tweet (@$tweets) {
			my $test = $tweet->{text};
			$heap->{irc}->yield('privmsg', $channel, $tweet->{text});
			$last_tweet = $tweet->{id} if $tweet->{id} > $last_tweet;
		}
	}
	$_[KERNEL]->alarm( check_twitter => time() + $delay);

}

$poe_kernel->run();

sub get_last_tweet {
	my $user = shift;
	my $t = Net::Twitter->new();
	my $states = $t->user_timeline({ id => $user });
	my $last = 0;
	for my $state ( @$states) {
	   $last = $state->{id} if $state->{id} > $last;
	}
	return $last;	
}

sub get_tweets_since {
	my ($user, $id) = (shift, shift);
	my $t = Net::Twitter->new();
	my $tweets = $t->user_timeline({id => $user, since_id => $id});
	return $tweets;
}

#print get_last_tweet('perl5examples');
#my $last_tweet = 1100006750;

#while (1) {
#	sleep (5);
#	my $tweets = get_tweets_since('perl6examples', $last_tweet);
#	for my $tweet ( @$tweets ) {
#		print "$tweet->{text}\n";
#		$last_tweet = $tweet->{id};
#	}
#}
	
