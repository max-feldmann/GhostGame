require 'set'

class Game
    ALPHABET = Set.new ("a".."z")

    def initialize(*players)
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = ["a", "b", "c"] #Set.new(words)
        @players = players
        @fragment = ""
    end

    attr_reader :dictionary, :players, :fragment

    def game_over?(fragment)
        @dictionary.include?(fragment)
    end

    def current_player
        @players.first
    end

    def previous_player
        @players[-1]
    end

    def next_player!
        @players.rotate!
    end

    def valid_play?(letter) 
        return false unless ALPHABET.include?(letter.downcase)                 # return false, if alphabet does not include the letter. downcased, because alphabet-set is completely lowercase.
        return false if letter.

        potential_fragment = @fragment + letter                             # potential fragment is existing fragment plus letter put in by play
        @dictionary.any? {|word| word.start_with?(potential_fragment)}      # goes through dictionary and checks every word. if any word starts_with? the potential fragment returns true. if not false
    end
end