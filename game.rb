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
        
        until we_got_a_winner
            guess = get_guess
            add_letter(guess)
            self.next_player!

            if fragment_is_word(@fragment)
                p "#{@fragment} is an actual word! You are out of the game!"
                @fragment = ""
                kick_player
                @remaining_players -= 1
            end

            if we_got_a_winner
                puts "\nWe have a Winner! #{current_player.name} has won!"
            end

        end
    end

    def we_got_a_winner
        @remaining_players == 1
    end

    def kick_player
            @loosers[previous_player.name] = true
    end
    
    def get_guess
        guess = @current_player.guess
        if valid_play?(guess)
            return guess
        else
            puts "This was not a valid guess. Has to be exactly one alphabetic letter!"
            get_guess
        end
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
            @fragment = @fragment + guessed_letter
    end

    def fragment_is_word(fragment)
        @dictionary.include?(fragment)
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
end