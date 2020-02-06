require 'set'
require_relative "player"

class Game
    # ALPHABET = Set.new ("a".."z")

    def initialize(*players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @alphabet = "abcdefghijklmnopqrstuvxyz"
        @dictionary = ["abc", "bac", "cba"] #Set.new(words)
        @players = []
            players.each{|player_name| @players << Player.new(player_name)}
        @fragment = ""
        @current_player = @players.first
    end

    attr_reader :dictionary, :players, :fragment, :current_player, :alphabet

    def take_turn
        game_over = false

        until game_over
            guessed_letter = get_guess
            
            if valid_play?(guessed_letter)
                add_letter(guessed_letter)
                self.next_player!
            else
                p "This was not a valid move, bro? Try again."
            end

            game_over = true if is_fragment_word?(@fragment)

                if game_over
                    p "#{@fragment} is an actual word! #{previous_player.name} has lost the game!"
                end
        end
    end

    # HANDLING THE PLAYERS
    def previous_player
        @players[-1]
    end

    def next_player!
        @current_player = @players.rotate!.first
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

    def add_letter(letter)
        @fragment = @fragment + letter
    end

    def is_fragment_word?(fragment)
        @dictionary.include?(fragment)
    end

end