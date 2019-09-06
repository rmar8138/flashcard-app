require "tty-prompt"
require "tty-table"
require_relative "../classes/Deck"

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

def edit_card_text(type, card_number, text)
  prompt = TTY::Prompt.new
  puts "Card #{card_number + 1}:"
  puts "\n"
  puts "#{type.upcase}: #{text}"
  puts "\n"
  return prompt.ask("Enter a new #{type}:")
end