# define class
class Card_bunch # bunch of cards, to be usd by hand and deck
  attr_accessor :cards
  end


class Card # duh
  attr_accessor :card_type
  attr_accessor :suit

  def initialize(card_type, suit)
    # Instance variables
    @card_type  = card_type
    @suit = suit
  end
end

class Hand < Card_bunch  # Basic Hand
  attr_accessor :score

  def initialize
    @score = 0
    @cards = []
  end


  def calc_score
    ace = false
    cards.each { | card |
    if card.card_type < 11
      self.score =  self.score + card.card_type
      if card.card_type == 1
        ace = true
      end
    else
      self.score = self.score + 10 # so pictures only get a 10
    end
    }
 self.score = self.score + 10 if ace == true and  self.score < 11
  end
  def get_card deck
    cards.push deck.cards.pop
  end

end

class Player_hand < Hand # adds player specific stuff
  attr_accessor :bet
  attr_accessor :balance
  attr_accessor :debt_limit
  def initialize
    @bet = 25 # default bet
    @balance = 5000 # starting cash
    @debt_limit = -5000 # how much you can go into debt
    @score = 0
    @cards = []
  end
end

class Deck < Card_bunch

  def initialize
    @cards = Array.new
  end

   def add_suit suit
     n = 0
     until n == 13
      self.cards.push Card.new n + 1, suit
      n= n + 1
     end
   end

   def shuffle_deck
     add_suit  'Spades'
     add_suit  'Hearts'
     add_suit  'Diamonds'
     add_suit  'Clubs'
     self.cards = cards.sort_by { rand }
   end
  end







player  = Player_hand.new
dealer = Hand.new
deck = Deck.new
deck.shuffle_deck
# Lets get started with the first 2 cards #
player.get_card deck
dealer.get_card deck
player.get_card deck
dealer.get_card deck
# player.show_hand





while true
  puts "enter your bet or q to quit (default is 50 or previous bet)"
  new_bet = gets.chomp
  if new_bet == 'q'
    puts 'Come back and play again! '
    break
  end
end







=begin
mm =  Card.new 3, "Spades"
ff = Card.new 7, 'hearts'
gg = Card.new 12, 'clubs'
pp.cards = Array.new
pp.cards[0] = mm
pp.cards[1] = ff
pp.cards[2] = gg
pp.calc_score
puts pp.score
=end





