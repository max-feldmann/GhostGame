require 'set'
require_relative "player"

class Game

    def initialize()
        words = File.readlines("dictionary.txt").map(&:chomp)
        @alphabet = "abcdefghijklmnopqrstuvxyz"
        @dictionary = Set.new(words)
        # @dictionary = ["abc", "bac", "cba"]    # Just for testing in Pry. (Loads forever if set alphabet is loaded)
        @players = []
        @fragment = ""
        @current_player = nil
        @loosers = {}
        @remaining_players = 0
    end

    attr_reader :dictionary, :players, :fragment, :current_player, :alphabet, :loosers

    def take_turn
        game_over = false

        while !game_over
            player_out = false
            make_move

            if @remaining_players == 1
                puts "That´s it, #{previous_player.name} has won the game!"
                game_over = true
            end
        end
    end

    def make_move
        self.next_player! if add_letter(get_guess)
        kick_player?
    end

    def kick_player?
        player_out = true if is_fragment_word?(@fragment)
                    
        if player_out
            p "#{@fragment} is an actual word! #{previous_player.name} is out of the game!"
            @loosers[previous_player.name] = true
            @fragment = ""
            @remaining_players -= 1
        end
    end

    # HANDLING THE PLAYERS
    def add_players(array_of_players)
        array_of_players.each do |player| 
            new_player = Player.new(player)
            @players << new_player
            @loosers[new_player.name] = false
            @remaining_players = array_of_players.length
        end
    end
    
    def set_current_player
        @current_player = @players.first
    end

    def previous_player
        @players[-1]
    end

    def next_player!
        @current_player = @players.rotate!.first
            next_player! if @loosers[@current_player.name] == true
    end
    
    def get_guess
        # guessed_letter = @current_player.guess
        @current_player.guess
    end

    # CHECKING AND WORKING WITH USER INPUT (GUESSES)
    def valid_play?(letter) 
        return false unless @alphabet.include?(letter.downcase)              # return false, if alphabet does not include the letter. downcased, because alphabet-set is completely lowercase.

        potential_fragment = @fragment + letter
        does_beginning_exist?(potential_fragment)
    end

    def does_beginning_exist?(fragment)
        @dictionary.any? {|word| word.start_with?(fragment)}                # goes through dictionary and checks every word. if any word starts_with? the potential fragment returns true. if not false
    end

    def add_letter(guessed_letter)
        if valid_play?(guessed_letter)
            @fragment = @fragment + guessed_letter
        else
            p "This was not a valid move, #{@current_player}? Try again."
        end
    end

    def is_fragment_word?(fragment)
        @dictionary.include?(fragment)
    end
end