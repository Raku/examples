use v6;

my $DEBUG = 0;

multi prompt ($prompt, @options is rw) {
    my $choice;
    for (@options.kv) -> $key, $item {
	   $item.key //= $key;
    }

    until (defined $choice && $choice ~~ any(@options.map: {.key})) {
        say $prompt;
        for @options -> $value {
		say "\t", $value.key, "\t", $value.text;
        }
        $choice = prompt;
    }

    my %options_by_key = @options.kv;
    $choice = %options_by_key.{$choice};
    
    return $choice.param // $choice.key;
}



sub cls { 
   #system(($*OS eq any <MSWin32 mingw>) ?? 'cls' !! 'clear'); 
 }

sub random ($low,$high) {int( rand($high - $low) + $low ) + 1; };
#multi sub infix:<.?.> ($low,$high) {int( rand($high - $low) + $low ) + 1; };

class Option {
    has Str $.key is rw ;
    has Str $.text is rw ;
    has Str $.param is rw ;
}

class WObject {
    has Str $.name     is rw;
    has Str $.location is rw;
    has Str $.last_location is rw;
    has Int $.plural;
    method where () {
        ($.name, ($.plural ?? 'are' !! 'is'), "currently in the", $.location).join;
    };
}

class Weapon is WObject {
    has Int $.power         is rw;
    has Int $.powerRange    is rw;
    method damage () { random($.power - $.powerRange, $.power + $.powerRange);};
}

class Mortal is WObject {
    has Int     $.life      is rw;
    has Int     $.max_life  is rw;

    has Weapon  $.weapon    is rw;
    method damage ($damage) {
           $.life -= $damage;
           $.life = 0 if $.life < 0;
    }

    method hit  (Mortal $enemy) {
      my $weapon = $.weapon;
      my $power  = $.weapon.damage;
      die "No enemy?" unless $enemy;
      if ($power > 0) {
            say $.name, " attacks ", $enemy.name(),
                "with ", $weapon.name(), " doing ", $power, " damage!";
            $enemy.damage($power);
      } elsif ($power < 0) {
            say $.name, "'s attack backfires, doing ", $power, " damage!";
            self.damage($power);
      }
    }
    method dead ()  { $.life <= 0 }
}

class Monster is Mortal {
	has $.gold is rw;
}

class Room is WObject {
   has Monster @.monsters is rw;
   has Str     @.exits is rw;
   method are_monsters () { @.monsters // 0 }
   method monster ()      {
      say '@.monsters : ', @.monsters.perl if $DEBUG;
      my $x = shift @.monsters;
      say 'shifted    : ', $x.perl if $DEBUG;
      say '@.monsters : ', @.monsters.perl if $DEBUG;
      return $x;
    }
};

class Person is Mortal {
    has Weapon  @.weapons   is rw;

    method battle (Mortal $enemy) {
        my $choice;

        say '';
        $enemy.life.say;
        say $enemy.name, " is attacking you! What will you do?";

        until ($choice eq 'f' or $enemy.dead) {
            my @options;
            for @.weapons -> $wep {
                @options.push( 
                     Option.new(
                         :text("attack with " ~ $wep.name),
                         :param($wep)
                     )
                );
            }
            
            @options.push( Option.new( :key<f>, :text("flee for your life")));
            $choice = prompt("Your choice? ", @options);
            cls;
            given $choice {
                when 'f' {
                    say "You ran away from the " , $enemy.name;
                }
                when .isa(Weapon) {
                    $.weapon = $_;
                    self.attack($enemy);
                }
                default {
                    say "Please enter a valid command!"
                }
            }
      }
      unless ($choice eq 'f') {
        say "The " , $enemy.name , " is dead!";
        return 1;
      }
      return 0;
    }

    method attack (Monster $enemy) {
        self.hit($enemy);
        $enemy.hit(self);

        say '';
        say "Your health: ", $.life, "/", $.max_life, "\t",
            $enemy.name(),": ", $enemy.life(), "/", $enemy.max_life();

        exit if self.dead;
    }


}

my $person = Person.new( Mortal{ :life(100),:max_life(100) },
    :weapons((Weapon.new(WObject{ :name<sword> }, :power(4), :powerRange(2)),
              Weapon.new(WObject{ :name<spell> }, :power(0), :powerRange(7)))),
);


my $frogs  = sub {
  my $life = (10..20).pick;
  my $m =  Monster.new( WObject{ :name("Army of frogs") }, 
                :gold( (0..100).pick),
                Mortal{ 
                    :life($life), 
                    :max_life($life) ,
                    :weapon( Weapon.new( 
                                   WObject{ :name<froggers> }, 
                                   :power(5), :powerRange(2)
                                    )
                           ) 
		   }
              );
   $m.life = $life;
   return $m;
};

my $bat    = sub {
    my $life = (20..30).pick;
    Monster.new(WObject{ :name("Bat")}, :gold( (0..100).pick ),
                Mortal{ :life($life), :max_life($life) ,
                        :weapon( Weapon.new(WObject{ :name<claws>}, :power(5), :powerRange(3))) 
                });
};
my $skeleton  = sub {
    my $life = (30..50).pick;
    Monster.new(WObject{ :name("Skeleton")}, :gold( (0..100).pick ), 
                Mortal{ :life($life),:max_life($life) ,
                        :weapon( Weapon.new(WObject{ :name<Fists> }, :power(5), :powerRange(10)))} );
};

my %world;
%world<Lobby>   = Room.new( WObject{ :name("Lobby")  }, :exits("Forest","Dungeon"), :monsters($frogs()));
%world<Forest>  = Room.new( WObject{ :name("Forest") }, :exits("Lobby"), :monsters($bat()));
%world<Dungeon> = Room.new( WObject{ :name("Dungeon")}, :exits("Lobby"), :monsters($skeleton()));
$person.last_location = $person.location = "Lobby";

$person.name = capitalize(prompt("What is your name: "));
say "Greetings, ", $person.name();
say $person.where;
until ($person.dead) {
  %world.{$person.location}.perl.say if $DEBUG;
  if (%world.{$person.location}.are_monsters) {
     my $monster = %world.{$person.location}.monster;
     unless ( $person.battle($monster) ) {
         push %world.{$person.location}.monsters, $monster;
         $person.location = $person.last_location;
     }
  } else {
     my @choices = %world.{$person.location}.exits.map: { Option.new( :text($_), :param($_)) };
     $person.last_location = $person.location;
     $person.location = prompt("Go to:" ,@choices);
     cls;
  }
}

# vim: ft=perl6
