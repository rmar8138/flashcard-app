require_relative "../classes/Deck"

def add_deck
  puts "Please enter a title for the deck"
  title = gets.chomp

  Deck.new(title)
end

def add_card(deck)
  puts deck.title
  puts "\n\n"
  puts "Card #{deck.cards.length + 1}"
  puts "\n\n"
  puts "Enter the question"
  question = gets.chomp
  puts "Enter the answer"
  answer = gets.chomp

  deck.add_card({ question: question, answer: answer })
end