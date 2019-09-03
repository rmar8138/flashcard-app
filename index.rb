require_relative "./classes/Deck"
require_relative "./modules/Database"
require_relative "./methods/methods"

database = Database.get

welcome_menu_open = true

while welcome_menu_open
  ##################
  # WELCOME SCREEN #
  ##################
  puts "Welcome to the terminal flash card app!"
  puts "\n\n"
  puts "Please select an option by typing in the number to the left:"
  puts "\n\n"
  puts "(1) Review\n(2) Add deck\n(3) Edit deck\n(4) Settings\n"
  puts "\nTo exit, hit the escape key once then press enter/return"
  puts "\n\n\n"

  input = gets.chomp
  p input
  case input
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
          system "clear"
        else
          puts "Invalid input"
        end
      end
    end
    database.push(new_deck.return_deck)
    Database.save(database)

    next
  when "3"
    #############
    # EDIT DECK #
    #############

    system "clear"
    edit_menu_open = true

    while edit_menu_open
      puts "Decks:"
      database.each_with_index do |deck, index|
        puts "(#{index + 1}) #{deck[:title]}: #{deck[:cards].length} card(s)"
      end
  
      puts "\n\n"
      puts "Which deck would you like to edit? Enter the number on the left"
      puts "\nTo exit, hit the escape key once then press enter/return"
  
      deck_number = gets.chomp
  
      if deck_number == "\e"
        system "clear"
        edit_menu_open = false
      elsif deck_number.to_i <= 0 || deck_number.to_i > database.length
        system "clear"
        puts "Invalid input"
        next
      else
        system "clear"
        edited_deck = Deck.new(database[deck_number.to_i - 1][:title], database[deck_number.to_i - 1][:cards])
        editing_deck = true

        while editing_deck
          puts "Would you like to add a card or edit? Enter the number on the left"
          puts "\n\n"
          puts "(1) Add\n(2) Edit"
          puts "\nTo exit, hit the escape key once then press enter/return"
          input = gets.chomp

          case input
          when "1"
            # ADD NEW CARD TO EXISTING DECK #
            add_card(edited_deck)
            database[deck_number.to_i - 1] = edited_deck.return_deck
            Database.save(database)
            database = Database.get
          when "2"
            # EDIT EXISTING CARD IN EXISTING DECK #
          when "\e"
            system "clear"
            edited_deck = false
            break
          else
            system "clear"
            puts "Invalid input"
            next
          end
        end
      end

    end

  when "4"
    ############
    # SETTINGS #
    ############

    system "clear"
    puts "Settings!"

    welcome_menu_open = false
  when "\e"
    system "clear"
    puts "Cya!"

    welcome_menu_open = false
  else
    system "clear"
    p input
    puts "Invalid input, please try again"
    next
  end
end
