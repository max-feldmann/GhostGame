require_relative "game"

class Session

    def initialize
        @players_joined = 0
        @number_of_players = self.greeting
        @this_session = nil
    end

    def run
        until @players_joined == @number_of_players
            session = Game.new(get_player_name)
        end

        session.take_turn
    end

    def get_player_name
          @players_joined += 1
            p "Player #{@players_joined}, what is your name?"
            player_name = gets.chomp
        
        player_name
    end

    # UI METHODS

    def greeting
        puts "\nWelcome to a game of GHOST!
        \nLet´s start!
        \nHow many players are you?"
        num_players = gets.chomp.to_i
    end
end

Session.new.run