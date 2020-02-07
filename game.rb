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

    # Until we got a winner (1 remaining player), a guess is received(get_guess checks for validity, so only correct guesses arrive here)
    # guess is then added to the fragment and next player is activated
    # Add letter checks if the fragment is now a word, that is in the dictionary. if it is, the active player is kicked.
    # if we got a winner after that guess, the game ends.
    def take_turn
        until we_got_a_winner
            add_letter(get_guess)
            self.next_player!

            if we_got_a_winner
                puts "\nWe have a Winner! #{current_player.name} has won!"
            end
        end
    end

    # If remaining players is down to 1, the last player has to be the winner
    def we_got_a_winner
        @remaining_players == 1
    end

    # Sets a players name in loosers-hash to true. Loosers are skipped by next_player!
    def kick_player
            @loosers[previous_player.name] = true
    end
    
    # asks a guess from current player
    # with valid_play? loop it is made sure, that only valid guesses are returned
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

    # return false, if alphabet does not include the letter. 
    # downcased, because alphabet-set is completely lowercase.
    # by calling does_beginning_exist? It is made sure, that players must not add nonsense to the fragment
    def valid_play?(letter) 
        return false unless @alphabet.include?(letter.downcase)              

        potential_fragment = @fragment + letter
        does_beginning_exist?(potential_fragment)
    end

    # goes through dictionary and checks every word. if any word starts_with? the potential fragment returns true. if not false
    def does_beginning_exist?(fragment)
        @dictionary.any? {|word| word.start_with?(fragment)}                
    end

    # adds a letter to the fragment.
    # it then checks whether fragment is a word from the dictionary.
    # if it is, the player is kicked(set to true in loosers / marked as a looser)
    def add_letter(guessed_letter)
            @fragment = @fragment + guessed_letter

            if fragment_is_word(@fragment)
                p "#{@fragment} is an actual word! You are out of the game!"
                @fragment = ""
                kick_player
                @remaining_players -= 1
            end
    end

    # checks if the fragment is a word from dict.
    def fragment_is_word(fragment)
        @dictionary.include?(fragment)
    end
    
    # HANDLING THE PLAYERS

    # receives an array of players from session.rb
    # goes through array catching every player
        # initialising new player
        # adding it to loosers as false (not a looser yet)
        # sets remaining_players to array length 
    def add_players(array_of_players)
        array_of_players.each do |player| 
            new_player = Player.new(player)
            @players << new_player
            @loosers[new_player.name] = false
            @remaining_players = array_of_players.length
        end
    end
    
    # current player is always first player of players array
    def set_current_player
        @current_player = @players.first
    end

    # previous player is alway last player of players array
    def previous_player
        @players[-1]
    end

    #rotates players once
    # if current player then is a looser, rotates it again
    def next_player!
        @current_player = @players.rotate!.first
            next_player! if @loosers[@current_player.name] == true
    end
end