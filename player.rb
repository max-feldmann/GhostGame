
class Player

    def initialize(name)
        @name = name
    end

    attr_reader :name

    # def ask_user_for_guess
    #     p "Hey #{self.name}Make a guess! (Has to be a single letter ;))"
    #     guess = gets.chomp.downcase
    #     guess
    # end

    def guess
        # rompt(fragment)
        gets.chomp.downcase
      end
end
