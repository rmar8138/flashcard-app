require "tty-prompt"
require "tty-table"
require_relative "../classes/Deck"

def edit_card_text(type, card_number, text)
  prompt = TTY::Prompt.new
  puts "Card #{card_number + 1}:"
  puts "\n"
  puts "#{type.upcase}: #{text}"
  puts "\n"
  return prompt.ask("Enter a new #{type}:")
end