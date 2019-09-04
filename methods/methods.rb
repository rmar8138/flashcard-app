require "tty-table"
require_relative "../classes/Deck"

def add_deck
  puts "Please enter a title for the deck"
  title = gets.chomp

  Deck.new(title)
end

def display_decks(decks)
  puts "Decks:"
  puts "\n"
  decks.each_with_index do |deck, index|
    puts "(#{index + 1}) #{deck[:title]}: #{deck[:cards].length} card(s)"
  end
  puts "\n"
end

def add_card(deck)
  puts "Deck: #{deck.title}"
  puts "Card #{deck.cards.length + 1}"
  puts " \n"
  puts "Enter the question"
  question = gets.chomp
  puts "Enter the answer"
  answer = gets.chomp

  deck.add_card({ question: question, answer: answer })
end

def display_card(card)
  puts "Question: #{card[:question]}"
  puts "Answer: #{card[:answer]}"
  puts "\n\n"
end

def display_cards(deck)
  deck.cards.each_with_index do |card, index|
    puts "(#{index + 1}) Question: #{card[:question]}"
    puts "Answer: #{card[:answer]}"
    puts "\n\n"
  end
end