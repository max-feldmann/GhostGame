require_relative "game"

class Session

    def initialize
        @players_joined = 0
        @number_of_players = self.greeting
        @this_session = nil
    end

    def start_session(players)
        #block darunter auslagern
        @session = Game.new
        @session.add_players(players)
        @session.set_current_player
        @session.take_turn
    end

    def boot_game
        players = []

        until @players_joined == @number_of_players
            players << self.get_player_names
        end

        start_session(players)

        restart_game?(players)
    end

    def restart_game?(players)
        puts "\n That was it! You want to play again?
            \n[y] to restart game
            \n[n] to leave"

            answer = gets.chomp.downcase

            if answer == "y" 
                start_session(players)
            else
                puts "\nAllrighty, see you next time!"
            end
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

        while num_players <= 1
            puts "\nYou have to be at least 2 Players to start a Session!\n"
            num_players = gets.chomp.to_i
        end
            return num_players
    end
end

Session.new.boot_game