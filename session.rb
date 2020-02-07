require_relative "game"

class Session

    def initialize
        @players_joined = 0
        @number_of_players = self.greeting
    end

    # Initialises a new game, adds [players] to the game, sets current player and starts first turn.
    def start_session(players)
        @session = Game.new
        @session.add_players(players)
        @session.set_current_player
        @session.play_game

        restart_game?(players)      # if game is over, next restart is called, which - if affirmative - calls start_session again
    end

    # Number of Players is set by greeting. As long as less players have joined, player names are asked and added to [players]
    def boot_game
        players = []

        until @players_joined == @number_of_players
            players << self.join_player
        end

        start_session(players)      # calls start session. This lets game.rb run until game is over and player decides to leave.
    end

    # if player wants to keep playing, a new session is started.
    def restart_game?(players)

        puts "\n That was it! You want to play again?
            \n[y] to restart game
            \n[n] to leave"
            answer = gets.chomp.downcase

            if answer == "y" 
                start_session(players)      
            else
                puts "\nAllrighty then, see you next time!"
            end
    end

    # --- UI METHODS TO INTERACT WITH PLAYERS---

    # Gets and return player names. Increments joined players every time.
    def join_player
        @players_joined += 1
        
          puts "\nPlayer #{@players_joined}, what is your name?\n"
          player_name = gets.chomp.to_s

      player_name
    end

    # welcomes the players and asks for the total number of players. also makes sure there are at least 2 players.
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