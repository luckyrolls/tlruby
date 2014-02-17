# define class
class Card
  attr_accessor :card
  attr_accessor :suit

  def initialize(card, suit)
    # Instance variables
    @card = card
    @suit = suit
  end
end

class Player_hand
  attr_accessor :hand1
  attr_accessor :score
  attr_accessor :ace_score # (holds the +11 # modifier for an ace)
  attr_accessor :balance
  attr_accessor :bet

  module GetCard
    def say_hello
      puts "Hello"
    end
  end


  def initialize(hand1, score, ace_score, balance)
    # Instance variables
    @hand1 = hand1
    @score = score
    @ace_score = ace_score
    @balance = balance
    @bet = bet
  end

end

def output_card card_value, suit, string

  case card_value
    when 1
      puts string + "  Ace of " + suit
    when 2...11
      puts string + "   " + card_value.to_s + ' of ' + suit
    when 11
      puts string + '   Jack ' + ' of ' + suit
    when 12
      puts string + ' Queen ' + ' of ' + suit
    when 13
      puts string + ' King of ' + suit
  end
end

def add_to_score card_value, base_score
  if card_value > 10
    card_value = 10
  end
  return base_score + card_value
end


def add_suit(deck, suit, offset)
  n = 0
  until n == 13
    deck[n + offset] = Card.new n + 1, suit
    n= n + 1
  end
end

def init_deck(deck)
  add_suit deck, 'Spades', 0
  add_suit deck, 'Hearts', 13
  add_suit deck, 'Diamonds', 26
  add_suit deck, 'Spades', 39
  deck = deck.sort_by { rand }
  return deck
end

def deck_get deck # re-shuffle deck when empty
  if deck.any?
    return deck.pop
  else
    puts 'Re-shuffling deck'
    init_deck(deck)
    return deck.pop
  end
end


def first_deal player_hand, deck

  player_hand.hand1[0] = deck_get deck # get first card
  player_hand.hand1[1] = deck_get deck # get second card
#   player_hand.hand1[0].card = 1  #debug
#  player_hand.hand1[1].card = 11  #debug  Ace
  player_hand.score = add_to_score player_hand.hand1[0].card, player_hand.score
  if player_hand.hand1[0].card == 1
    player_hand.ace_score = player_hand.score + 10
  end
  player_hand.score = add_to_score player_hand.hand1[1].card, player_hand.score
  if player_hand.hand1[1].card == 1 and player_hand.ace_score == 0 # if first ace, set ace  score
    player_hand.ace_score = player_hand.score + 10
  elsif player_hand.ace_score > 0 and player_hand.ace_score +  player_hand.hand1[1].card < 22
    player_hand.ace_score = player_hand.ace_score + player_hand.hand1[1].card # only an option if it is less than 22
  end
  output_card player_hand.hand1[0].card, player_hand.hand1[0].suit, 'You have a'
  output_card player_hand.hand1[1].card, player_hand.hand1[1].suit, 'You have a'



  return deck

end

def first_dealer dealer, deck

  dealer.hand1[0] = deck_get deck # get first card
  dealer.hand1[1] = deck_get deck # get second card
  # dealer.hand1[0].card = 9  #debug Jack

  # dealer.hand1[1].card = 10  #debug  Ace

  if dealer.hand1[0].card == 1 # First dealer ace always scores 11
    dealer.score = 11
  else
    dealer.score = add_to_score dealer.hand1[0].card, dealer.score
  end

  if dealer.hand1[0].card == 1 and dealer.score < 11 # second ace will be 11 unless first card was an ace
    dealer.score = dealer.score + 11
  else
    dealer.score = add_to_score dealer.hand1[1].card, dealer.score
  end
  output_card dealer.hand1[0].card, dealer.hand1[0].suit, 'Dealer is showing a'
  # output_card dealer.hand1[1].card, dealer.hand1[1].suit, 'Dealer has a'
  # puts 'Dealer score so far is ' + dealer.score.to_s + ' points'


  return
end

def check_blackjack player
  if player.hand1[0].card == 1 or player.hand1[1].card == 1 # check for ace
    return true if player.hand1[0].card > 10 or player.hand1[1].card > 10 #check for picture
  end
  return false # no blackjack
end

def initial_deal player_hand, dealer, deck # deal first 2 cards


end


def deal_card player_hand, deck
  next_card = deck_get deck
  player_hand.hand1.push next_card
end

def output__final player

end

def calc_winner player, dealer

  if dealer.score > 21
    puts 'Dealer busted ... YOU WIN'
    player.balance = player.balance + player.bet
    return
  end
  if player.ace_score != 0 # determine the highest possible score based on ace
    player_final = player.ace_score
  else
    player_final = player.score
  end
  if player_final < dealer.score
    puts "Loser!"
    player.balance = player.balance - player.bet
  elsif player_final == dealer.score
    puts 'Tie - nobody wins'
  else puts 'You win ... you rock!'
  player.balance = player.balance + player.bet
  end
end

def play_blackjack
  deck=[]
  deck = init_deck deck
  balance = 2000 # starting cash
  bet = 50
  while true
    puts "enter your bet or q to quit (default is 50 or previous bet)"
    new_bet = gets.chomp
    if new_bet == 'q'
      puts "CCCYYYAAAA"
      break
    end

    if new_bet.to_i > 0
      bet = new_bet.to_i
      puts 'Your bet is now ' + bet.to_s
    else
      puts 'Your bet is still ' + bet.to_s
    end


    # initialize stuff

    player = Player_hand.new [], 0, 0, 0
    dealer = Player_hand.new [], 0, 0, 0
    player.bet = bet
    player.balance = balance
    puts "you have " + player.balance.to_s + " dollars"

    deck = first_deal player, deck # 2 cards to player and 2 cards to house
    first_dealer dealer, deck
    player_blackjack = check_blackjack player
    dealer_blackjack = check_blackjack dealer
    if player_blackjack == true and dealer_blackjack == true
      puts 'That is a push - both have blackjack'
    elsif player_blackjack == true
      puts 'Blackjack - woohoo - you win'
      player.balance = player.balance + player.bet
      balance = player.balance
    elsif dealer_blackjack == true
      puts ' Dealer has blackjack, you lose '
      player.balance = player.balance - player.bet
      balance = player.balance
    end

    if dealer_blackjack != true and player_blackjack != true
      while true # player loop
        puts ' Would you like another card? Enter Y or N to stand'
        resp = gets.chomp.downcase()
        if resp == 'n' # the fill out dealer cards
          output_card dealer.hand1[1].card, dealer.hand1[1].suit, 'Dealer reveals a'
          while true
            if dealer.score > 16
              break
            else
              dealer.hand1.push deck_get deck
              output_card dealer.hand1.last.card, dealer.hand1.last.suit, 'Dealer got a '
              dealer.score = add_to_score dealer.hand1.last.card, dealer.score
              if dealer.hand1.last.card == 1 and dealer.score < 12 # if Ace - give dealer 11 if possible
                dealer.score = dealer.score + 10 # +10 because I already added in the 1
              end
            end
          end
          calc_winner player, dealer
          puts ' '
          puts 'new game'
          balance = player.balance
          break

        elsif resp == "y"
          cur_card = deck_get deck
          # cur_card.card = 1 # debug ace
          player.score = add_to_score cur_card.card, player.score
          if player.ace_score > 0 and player.ace_score + cur_card.card < 22 # add the card to the ace_score - if there have been previous aces
            player.ace_score = player.ace_score + cur_card.card
          elsif cur_card.card == 1 and player.ace_score == 0 and player.score + 10 < 22 #If it is the first ace, calculate the possible ace score.
            player.ace_score = player.score + 10
          end
          output_card cur_card.card, cur_card.suit, 'You have got a '

          if player.score > 21
            puts "BUSTED!!"
            player.balance = player.balance - player.bet
            puts ' '
            puts 'new game'
            balance = player.balance
            break
          end
        end
      end
    end
  end
end

mm = 5

mm = 3
play_blackjack


# Lots of refactoring to do but it works!
