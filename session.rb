require_relative "game"

class Session

    def initialize
        @players_joined = 0
        @number_of_players = self.greeting
        @this_session = nil
    end

    def boot_game
        players = []

        until @players_joined == @number_of_players
            players << self.get_player_names
        end

        @session = Game.new
        @session.add_players(players)
        @session.set_current_player
        @session.take_turn

        puts "\n \n Thank´s alot for swinging by! See you next time ;)"
    end

    def get_player_names
          @players_joined += 1
            puts "\nPlayer #{@players_joined}, what is your name?\n"
            player_name = gets.chomp.to_s
        
        player_name
    end

    # UI METHODS

    def greeting
        puts "\nWelcome to a game of > GHOST < !!!
        \nLet´s start!
        \nHow many players are you?"
        num_players = gets.chomp.to_i
    end
end

Session.new.boot_game