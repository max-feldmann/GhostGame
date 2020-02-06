require 'set'
require_relative "player"

class Game
    ALPHABET = Set.new ("a".."z")

    def initialize(*players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = ["abc", "bac", "cba"] #Set.new(words)
        @players = []
            players.each{|player_name| @players << Player.new(player_name)}
        @fragment = ""
        @current_player = @players.first
    end

    attr_accessor :dictionary, :players, :fragment, :current_player

    def get_guess
        guessed_letter = players.first.guess
    end

    def take_turn
        game_over = false

        until game_over
            guessed_letter = @current_player.guess
            
            if valid_play?(guessed_letter)
                add_letter(guessed_letter)
                self.next_player!
            else
                p "This was not a valid move, bro? Try again."
            end
        end
    end

    def previous_player
        @players[-1]
    end

    def next_player!
        @players.rotate!
    end

    def valid_play?(letter) 
        return false unless ALPHABET.include?(letter.downcase)              # return false, if alphabet does not include the letter. downcased, because alphabet-set is completely lowercase.

        potential_fragment = @fragment + letter
        has_beginning?(potential_fragment)
    end

    def has_beginning?(fragment)
        @dictionary.any? {|word| word.start_with?(fragment)}                # goes through dictionary and checks every word. if any word starts_with? the potential fragment returns true. if not false
    end

    def add_letter(letter)
        @fragment = @fragment + letter
    end

end