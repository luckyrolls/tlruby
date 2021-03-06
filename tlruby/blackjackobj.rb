
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
    if not deck.cards.any? # when empty, reshuffle
      deck.shuffle_deck
      puts 'Shuffling deck ... '
      sleep (1)
    end
    cards.push deck.cards.pop
    calc_score
  end
end

class Player_hand < Hand # adds player specific stuff
  attr_accessor :bet
  attr_accessor :balance
  attr_accessor :debt_limit
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
    self.cards = cards.sort_by { rand }
  end
end

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

def get_bet player
  still_playing  = true
  if player.balance < -5000
    puts 'You wallet is empty - go home!'
    still_playing = false
  else
  puts 'You have ' + player.balance.to_s +  ' dollars'
  puts "enter your bet or q to quit (default is 50 or previous bet)"
  new_bet = gets.chomp
  if new_bet == 'q'
    puts 'Come back and play again! '
   still_playing = false
   elsif new_bet.to_i > 0
    player.bet = new_bet.to_i
    puts 'Your bet is now ' + player.bet.to_s
  else
    puts 'Your bet is still ' + player.bet.to_s
  end
  end
  return still_playing
end



def first_deal (player, dealer, deck) # deal first set of cards
  i = 0
  while i < 2  # get first 2 cards
    player.get_card deck
    dealer.get_card deck
    i = i + 1
  end
  output_card player.cards[0], "You received a" # a little redundant, but hardly worth another loop
  output_card player.cards[1], "You received"
  puts "You have " + player.score.to_s + " points"
  output_card dealer.cards[0], "Dealer is showing a"
# output_card dealer.cards[1], "Dealer received a" # Only see this when testing
# puts "Dealer has " + dealer.score.to_s + " points" # dito
end



def dealer_loop dealer, player, deck
  still_dealing = true
  while still_dealing # dealer loop
    if dealer.score > 16
      calc_winner player, dealer
      still_dealing = false
    else
      still_dealing = true
      sleep (1)
      dealer.get_card deck
      output_card dealer.cards[dealer.cards.count - 1], 'Dealer got a'
      puts 'Dealer now have ' + dealer.score.to_s + ' points!'
      if dealer.busted?
        puts 'Dealer busted - you win!'
        player.balance = player.balance + player.bet
        still_dealing = false
        return false
      end
    end
  end

end



def player_loop (dealer, player, deck)
  still_playing = true
  while still_looping # player loop
    puts 'Would you like another card? Enter Y or N to stand'
    resp = gets.chomp.downcase()
    if resp == 'y' # Start hit loop for player
      sleep (1)
      player.get_card deck
      output_card player.cards[player.cards.count - 1], 'you got a'
      puts 'You now have ' + player.score.to_s + ' points!'
      if player.busted?
        puts 'Busted - you lose!'
        player.balance = player.balance - player.bet
        still_playing = false
        still_looping = false
      end
    else
      still_looping = false
      # game continues
    end
  end
  return still_playing
end

# Main loop

still_playing = true
player = Player_hand.new
deck = Deck.new
while still_playing
  if get_bet player
    dealer = Hand.new
  #  deck.shuffle_deck
    player.score = 0 # re-init from prev game
    player.cards = [] # re-init form prev game
# Lets get started with the first 2 cards #
    first_deal(player, dealer, deck)
    unless any_blackjacks? player, dealer #  only continue if no blackjacks
      if player_loop dealer, player, deck
        output_card dealer.cards[1], "Dealer reveals a "
        puts "Dealer has " + dealer.score.to_s + " points"
        dealer_loop dealer, player, deck
      end
    end
    else still_playing = false
  end
end
