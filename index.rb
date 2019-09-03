require_relative "./classes/Deck"
require_relative "./modules/Database"

database = Database.get
p database

def add_deck
  puts "Please enter a title for the deck"
  title = gets.chomp

  Deck.new(title)
end

welcome_menu_open = true

while welcome_menu_open
  ##################
  # WELCOME SCREEN #
  ##################

  puts "\n\n\n"
  puts "Welcome to the terminal flash card app!"
  puts "\n\n"
  puts "Please select an option by typing in the number to the left:"
  puts "\n\n"
  puts "(1) Review\n(2) Add deck\n(3) Edit deck\n(4) Settings\n(5) Exit"
  puts "\n\n\n"

  option = gets.chomp

  case option
  when "1"
    system "clear"
    puts "Review!"

    welcome_menu_open = false
  when "2"
    ############
    # ADD DECK #
    ############

    system "clear"
    new_deck = add_deck
    
    system "clear"
    finished_adding_cards = false
    until finished_adding_cards
      puts new_deck.title
      puts "\n\n"
      puts "Card #{new_deck.cards.length + 1}"
      puts "\n\n"
      puts "Enter the question"
      question = gets.chomp
      puts "Enter the answer"
      answer = gets.chomp

      new_deck.add_card({ question: question, answer: answer })

      add_another_card_prompt_open = true
      while add_another_card_prompt_open
        puts "Add another card? (y/n)"
        input = gets.chomp
        
        case input
        when "y"
          system "clear"
          add_another_card_prompt_open = false
        when "n"
          add_another_card_prompt_open = false
          finished_adding_cards = true
        else
          puts "Invalid input"
        end
      end
    end
    database[new_deck.title.to_sym] = {
      title: new_deck.title,
      cards: new_deck.cards
    }
    Database.save(database)

    welcome_menu_open = false
  when "3"
    #############
    # EDIT DECK #
    #############

    system "clear"
    puts "Edit!"

    welcome_menu_open = false
  when "4"
    ############
    # SETTINGS #
    ############

    system "clear"
    puts "Settings!"

    welcome_menu_open = false
  when "5"
    system "clear"
    puts "Cya!"

    welcome_menu_open = false
  else
    system "clear"
    puts "Invalid input, please try again"
    next
  end
end
