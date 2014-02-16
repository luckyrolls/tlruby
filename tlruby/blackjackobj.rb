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

class Hand < Card_bunch

  def score
    score=0
    cards.each { | card |
    if card.card_type < 11
      score = score + card.card_type
    else
      score = score + 10 # so pictures only get a 10
    end
    }
    return score
    end

  
end



class Deck < Card_bunch

   def add_suit(deck, suit, offset)
     n = 0
     until n == 13
      cards[n + offset] = Card.new n + 1, suit
      n= n + 1
     end
   end

   def init_deck
     add_suit self, 'Spades', 0
     add_suit self, 'Hearts', 13
    add_suit self, 'Diamonds', 26
     add_suit self, 'Spades', 39
    # deck = deck.sort_by { rand }
    # return deck
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

pp = Hand.new
deck = Deck.new
deck.cards = Array.new
deck.init_deck

pp.cards = Array.new
pp.cards[0] = mm
pp.cards[1] = ff
pp.cards[2] = gg
puts pp.score

# Victory - just finihsed how to instantiate deck



