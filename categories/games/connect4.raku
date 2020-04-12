#!/usr/bin/env perl6

use v6;

=begin pod

=TITLE Connect4

=AUTHOR David Whipp

Play the L<Connect4|http://en.wikipedia.org/wiki/Connect_Four> game.

=end pod

# pre-declare types
class Game { ... };
class Move { ... };

class Player {
    has Str $.token;
    has Str $.highlighter_token;

    method get_move( Game $game ) { ... };
}

class HumanPlayer is Player {
    has Str $.token;
    has Str $.highlighter_token;

    method get_move( Game $game ) {

        my @legal_moves = $game.legal_moves( self );

        loop {
            my $user_input =
                prompt("Enter column number for {$.token} to play: ");
            if @legal_moves.first: { .column == $user_input-1 } -> $move {
                return $move;
            }
            else {
                say "move must be a legal (not full) column number";
            }
        }

    }
}

class ComputerPlayer is Player {

    has Str $.token;
    has Str $.highlighter_token;

    has Int $.look_ahead;

    method get_move_choices ( Game $game, $debug = 1 ) {
        my @legal_moves = $game.legal_moves( self );

        if $.look_ahead > 0 && @legal_moves.grep: { .is_winning_move } -> @winning_moves {
            say "'$.token' has winning moves: {@winning_moves.map({.column + 1})}" if $debug > 0;
            return @winning_moves;
        }
        elsif $.look_ahead > 1 && @legal_moves.grep: { ! .gives_opponent_a_winning_move } -> @ok_moves {
            if $.look_ahead > 2 && @ok_moves.grep: { .gives_opponent_only_losing_moves } -> @better_moves {
                say "'$.token' likes to play one of {@better_moves.map({.column + 1})}" if $debug > 0;
                return @better_moves;
            }
            else {
                say "'$.token' should play one of {@ok_moves.map({.column + 1})}" if $debug > 0;
                return @ok_moves;
            }
        }
        else {
            say "'$.token' has no move preference" if $debug > 0;
            return @legal_moves;
        }
    }

    method get_move( Game $game ) {
        my Move $where = $.get_move_choices($game).pick();
    }
}

class Game {
    has @board;
    has Int @current_levels;

    has @.player_types;

    has Player @players;

    method clear_board() {
        if @.player_types.elems != 2 {
            die "invalid game spec: {@.player_types} -- expencted list of two elems, each is either strength or 'H' for human";
        }
        @players = ();

        if @.player_types[0] eq "H" {
            @players.push: HumanPlayer.new( token => "X", highlighter_token => "*" )
        }
        else {
            @players.push: ComputerPlayer.new( token => "X", highlighter_token => "*", look_ahead => @.player_types[0] )
        }

        if @.player_types[1] eq "H" {
            @players.push: HumanPlayer.new( token => "O", highlighter_token => "@" )
        }
        else {
            @players.push: ComputerPlayer.new( token => "O", highlighter_token => "@", look_ahead => @.player_types[1] )
        }

        @board = (^7).map({[ "" xx 7 ]});
        @current_levels = 0 xx 7;
    }

    method other_player( Player $who ) {
        @players.first: { $_ !=== $who };
    }

    method next_available_row_of_column( Int $column ) {
        if (@board[6][$column]) {
            die "illegal move: $column";
        }
        return @current_levels[$column];
    }

    multi method set_board_state( Move $move ;; $value = $move.who.token ) {
        @board[$move.row][$move.column] = $value;
    }

    multi method set_board_state( Int $row, Int $column ;; $value ) {
        @board[$row][$column] = $value
    }

    method play_move( Move $move ) {
        self.set_board_state: $move;
        ++@current_levels[$move.column];
    }

    method undo_move( Move $move ) {
        self.set_board_state: $move, "";
        --@current_levels[$move.column];
    }

    method scan_for_win( Move $move, $fn ) {

        my $token = $move.who.token;
        my $column = $move.column;
        my $row = $move.row;

        for -1, 0, +1 -> $diag {
            my @winning_points;
            for -1, +1 -> $left_right {
                for 1 .. 3 -> $delta_x {
                    my $x = $column + ( $delta_x * $left_right );
                    my $y = $row + ( $delta_x * $left_right * $diag );
                    last unless 0 <= $x <= 6;
                    last unless 0 <= $y <= 6;
                    last unless @board[$y][$x] eq $token;
                    push @winning_points, [$y, $x];
                }
            }
            $fn( @winning_points ) if @winning_points >= 3;
        }

        if $row > 2 {
            my @winning_points = (1..3).map: -> $delta_y { [$row - $delta_y, $column] };
            for @winning_points -> @p {
                # TODO: @board[ [;] @p ] eq $token
                my ($y, $x);
                ($y, $x) = @p;
                return unless @board[$y][$x] eq $token;
            }
            $fn( @winning_points );
        }
    }

    method highlight_position( Move $move, *@points ) {
        self.set_board_state: $move, "#";
        my $token = $move.who.highlighter_token;
        for @points -> @p { self.set_board_state: |@p, $token }
    }

    method display {
        say (1..7).join("   ");
        .map({ $_ || "-" }).join(" | ").say for reverse @board;
    }


    method legal_moves (Player $who) {
        my @moves;
        for ^7 -> $column {
            push @moves, Move.new( game => self, who => $who, column => $column) unless @board[6][$column];
        }
        return @moves;
    }

    method play_game {
        self.clear_board;
        self.display;

        for ^49 -> $move_num {
            my $who = @players[ Int($move_num % 2) ];
            my Move $where = $who.get_move( self );
            my $win = $where.is_winning_move;
            say "";
            $where.play;
            self.display;
            if $win {
                say "{$who.token} WINS on move { Int($move_num/2) + 1 }!";
                return;
            }
        }
        say "DRAW"
    }
}

class Move {
    has Game $.game;

    has Player $.who;
    has Int $.column;
    has Int $!row;
    has Player $!other;

    method row () {
        $!row = $.game.next_available_row_of_column( $.column ) unless defined $!row;
        return $!row
    };

    method perl () { "Move( :who<{$.who.token}> :col<$.column> :row<$.row> )" };

    method opponent() {
        unless defined $!other {
            $!other = $.game.other_player( $.who );
        }
        return $!other;
    }

    method is_winning_move() {
        my $win = False;
        $.game.scan_for_win: self, { $win = True };
        return $win;
    }

    method mark_winning_move( ) {
        $.game.scan_for_win: self, -> @points {
            $.game.highlight_position( self, @points );
        }
    }

    method play() {
        say "play '{$.who.token}' -> {$.column+1}";
        self.game.play_move( self );
        self.mark_winning_move;
    }

    method play_hypothetical() {
        self.game.play_move( self )
    }

    method undo() {
        self.game.undo_move( self )
    }

    method gives_opponent_a_winning_move() {
        self.play_hypothetical;

        my @legal_moves = self.game.legal_moves( $.opponent );
        my $other_wins = ? @legal_moves.grep: { .is_winning_move };

        self.undo;

        return $other_wins;
    }

    method gives_opponent_only_losing_moves() {

        self.play_hypothetical;

        my @legal_moves = self.game.legal_moves( $.opponent );
        my @other_losing_moves = @legal_moves.grep: { .gives_opponent_a_winning_move };

        self.undo;

        return @other_losing_moves == @legal_moves;
    }
}

my Game $game.=new( player_types => ( "H", 2 ) );
$game.play_game;

# vim: expandtab shiftwidth=4 ft=perl6
