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

  def initialize (score)
    @score = score
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
end

class Player_hand < Hand # adds player specific stuff
  attr_accessor :bet
  attr_accessor :balance
  attr_accessor :debt_limit
  def initialize score, bet, balance, debt_limit
    @bet = bet
    @balance = balance
    @debt_limit = debt_limit
    super(score)
  end
end

class Deck < Card_bunch

   def add_suit( suit, offset)
     n = 0
     until n == 13
      cards[n + offset] = Card.new n + 1, suit
      n= n + 1
     end
   end

   def init_deck
     add_suit  'Spades', 0
     add_suit  'Hearts', 13
     add_suit  'Diamonds', 26
     add_suit  'Spades', 39
     self.cards = cards.sort_by { rand }
   end

=begin
  def init_deck
  cards[0] = Card.new 3, "spades"

  end
=end


  end


# attr_accessor :hand

#    def deck_init

#     end



mm =  Card.new 3, "Spades"
ff = Card.new 7, 'hearts'
gg = Card.new 12, 'clubs'

pp = Player_hand.new 0, 25, 500, 5000
deck = Deck.new
deck.cards = Array.new
deck.init_deck

pp.cards = Array.new
pp.cards[0] = mm
pp.cards[1] = ff
pp.cards[2] = gg
pp.calc_score
puts pp.score





