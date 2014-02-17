
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

  def busted?
    if score > 21
      return true
    end
  end



  def calc_score
    self.score = 0 #
    cards.each { | card |
    if card.card_type < 11
      self.score =  self.score + card.card_type
      if card.card_type == 1 and self.score < 12 # make the ace 10 if you can
        self.score = self.score + 10
      end
    elsif card.card_type > 10 # Picture card only worth 10
      self.score = self.score + 10
    end
    }
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
  attr_accessor :score
  attr_accessor :cards
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
     i = 0
     while i < 15
       self.cards.push Card.new 1, 'fung' # put in a bunch of Aces for testing
       i = i + 1
     end


     self.cards = cards.sort_by { rand }
=begin
     self.cards.push Card.new 1, 'ten' # Debugging
     self.cards.push Card.new 1, 'ten'
     self.cards.push Card.new 11, 'ten'
     self.cards.push Card.new 11, 'ten'
=end
   end
end

  def any_blackjacks? player, dealer
    player_bj = player.check_blackjack
    dealer_bj = dealer.check_blackjack
    if player_bj == true and dealer_bj == true
      puts 'That is a push - both have blackjack'
      return true
    elsif player_bj == true
      puts 'Blackjack - woohoo - you win'
      player.balance = player.balance + player.bet
      return true
    elsif dealer_bj == true
      puts ' Dealer has blackjack, you lose '
      player.balance = player.balance - player.bet
      return true
    end
      return false
  end


  def calc_winner player, dealer


    if player.score < dealer.score
      puts "Loser!"
      player.balance = player.balance - player.bet
    elsif player.score == dealer.score
      puts 'Tie - nobody wins'
    else puts 'You win ... you rock!'
    player.balance = player.balance + player.bet
    end
  end


# Main loop


player  = Player_hand.new
  while true
   puts 'You have ' + player.balance.to_s +  ' dollars'
   puts "enter your bet or q to quit (default is 50 or previous bet)"
   new_bet = gets.chomp
   if new_bet == 'q'
      puts 'Come back and play again! '
      break
   end
dealer = Hand.new
deck = Deck.new
deck.shuffle_deck
player.score = 0 # re-init from prev game
player.cards = [] # re-init form prev game

i = 0
   while i < 2  # get first 2 cards
     player.get_card deck
     dealer.get_card deck
     i = i + 1
   end
# Lets get started with the first 2 cards #

output_card player.cards[0], "You received a" # a little redundant, but hardly worth another loop
output_card player.cards[1], "You received"
puts "You have " + player.score.to_s + " points"
output_card dealer.cards[0], "Dealer received a"
output_card dealer.cards[1], "Dealer received a"
puts "Dealer has " + dealer.score.to_s + " points"
unless any_blackjacks? player, dealer #  only continue if now blackjacks
still_playing = true
while still_playing # player loop
  puts ' Would you like another card? Enter Y or N to stand'
  resp = gets.chomp.downcase()
  if resp != 'n'  # Start hit loop for player
    player.get_card deck
    output_card player.cards[player.cards.count - 1], 'you got a'
    puts 'You now have ' + player.score.to_s + ' points!'
    if player.busted?
      puts 'Busted - you lose!'
      player.balance = player.balance - player.bet
      break
    end
  else
  while still_playing # dealer loop
    if dealer.score > 16
      calc_winner player, dealer
      still_playing = false
      break
    end
    dealer.get_card deck
    output_card dealer.cards[dealer.cards.count - 1], 'Dealer got a'
    puts 'Dealer now have ' + dealer.score.to_s + ' points!'
    if dealer.busted?
      puts 'Dealer busted - you win!'
      player.balance = player.balance + player.bet
      still_playing = false
    end
  end
  end
end
end
end















