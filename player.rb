class Player

    def initialize(name)
        @name = name
    end

    attr_reader :name, :guess

    # Simply asks player for a guess and returns the answer
    def guess
            p "Hey #{self.name} make a guess! (Has to be a single letter ;))"
            guess = gets.chomp.downcase
        guess
    end
end
