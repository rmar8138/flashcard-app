require "tty-prompt"
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

def create_card(deck)
  prompt = TTY::Prompt.new
  
  puts "Deck: #{deck.title}"
  puts "\n\n"
  puts "Card #{deck.cards.length + 1}"
  puts "\n\n"
  question = prompt.ask("Enter the question:")
  answer = prompt.ask("Enter the answer:")

  return { question: question, answer: answer }
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