
  def output_card(card, string)
    case card.card_type
      when 1
        puts string + "  Ace of " + card.suit
      when 2...11
        puts string + "   " + card.card_type.to_s + ' of ' + card.suit
      when 11
        puts string + '   Jack ' + ' of ' + card.suit
      when 12
        puts string + ' Queen ' + ' of ' + card.suit
      when 13
        puts string + ' King of ' + card.suit
    end
  end


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

  def check_blackjack
    if cards[0].card_type == 1 or cards[1].card_type == 1
      return true if cards[0].card_type > 10 or cards[1].card_type > 10 #check for picture
    end
    return false # no blackjack
  end


  def calc_score
    self.score = 0
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
    calc_score
  end

end

class Player_hand < Hand # adds player specific stuff
  attr_accessor :bet
  attr_accessor :balance
  attr_accessor :debt_limit
  def initialize
    @bet = 50 # default bet
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

 while true
   puts "enter your bet or q to quit (default is 50 or previous bet)"
   new_bet = gets.chomp
   if new_bet == 'q'
      puts 'Come back and play again! '
      break
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
output_card player.cards[0], " You received a"
output_card player.cards[1], " You received"
puts "You have " + player.score.to_s + " points"
output_card dealer.cards[0], " Dealer received a"
output_card dealer.cards[1], " Dealer received a"
puts "Dealer has " + dealer.score.to_s + " points"

  player.check_blackjack
dealer.check_blackjack
# player.show_hand

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





