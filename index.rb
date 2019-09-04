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
      puts "Deck: #{new_deck.title}"
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
          puts "Deck: #{edited_deck.title}" 
          puts "Cards: #{edited_deck.cards.length} card(s)"
          puts "\n"
          puts "Would you like to add, edit or delete? Enter the number on the left"
          puts "\n"
          puts "(1) Add Card\n(2) Edit Card\n(3) Delete Card\n(4) Edit Deck Title"
          puts "\nTo exit, hit the escape key once then press enter/return"
          input = gets.chomp

          case input
          when "1"
            # ADD NEW CARD TO EXISTING DECK #
            system "clear"

            add_card(edited_deck)
            database[deck_number.to_i - 1] = edited_deck.return_deck
            Database.save(database)
            database = Database.get

            system "clear"
            next
          when "2"
            # EDIT EXISTING CARD IN EXISTING DECK #
            system "clear"
            display_cards(edited_deck)

            puts "Which card would you like to edit? Enter the number to the left"
            card_number = gets.chomp

            if card_number.to_i <= 0 || card_number.to_i > edited_deck.cards.length
              system "clear"
              puts "Invalid input"
              next
            else
              system "clear"
              user_editing_card = true

              while user_editing_card
                puts "Card #{card_number}"
                puts "\n"
                puts "Question: #{edited_deck.cards[card_number.to_i - 1][:question]}"
                puts "Answer: #{edited_deck.cards[card_number.to_i - 1][:answer]}"
                puts "\n"
                puts "(1) Edit Question"
                puts "(2) Edit Answer"
                puts "(3) Exit"
                puts "\n"
                puts "Would you like to edit the question, the answer, or exit? Enter the number to the left"
                input = gets.chomp

                case input
                when "1"
                  # EDIT QUESTION #
                  system "clear"
                  puts "Card #{card_number}:"
                  puts "\n"
                  puts "Question: #{edited_deck.cards[card_number.to_i - 1][:question]}"
                  puts "\n"
                  puts "Enter a new question"
                  new_question = gets.chomp

                  edited_deck.edit_card("question", new_question, card_number.to_i - 1)
                  
                  Database.save(database)
                  database = Database.get
                  system "clear"
                  next
                when "2"
                  # EDIT ANSWER #
                  system "clear"
                  puts "Card #{card_number}:"
                  puts "\n"
                  puts "Answer: #{edited_deck.cards[card_number.to_i - 1][:answer]}"
                  puts "\n"
                  puts "Enter a new answer"
                  new_answer = gets.chomp

                  edited_deck.edit_card("answer", new_answer, card_number.to_i - 1)
                  
                  Database.save(database)
                  database = Database.get
                  system "clear"
                when "3"
                  system "clear"
                  user_editing_card = false
                  next
                else
                  system "clear"
                  puts "Invalid input"
                  next
                end
              end
            end
          when "3"
            # DELETE EXISTING CARD FROM EXISTING DECK #
            if edited_deck.cards.length == 0
              system "clear"
              puts "No cards in this deck to delete!"
              puts "\n"
              next
            else
              system "clear"
  
              deleting_card = true
  
              while deleting_card
                display_cards(edited_deck)
                puts "Which card would you like to delete? Enter the number to the left"
                card_number = gets.chomp
  
                if card_number.to_i <= 0 || card_number.to_i > edited_deck.cards.length
                  system "clear"
                  puts "Invalid input"
                  next
                else
                  system "clear"

                  puts "Are you sure you want to delete this card? (y/n)"
                  puts "\n"
                  display_card(edited_deck.cards[card_number.to_i - 1])
                  input = gets.chomp
  
                  case input
                  when "y"
                    edited_deck.delete_card(card_number.to_i - 1)
                    database[deck_number.to_i - 1] = edited_deck.return_deck
                    Database.save(database)
                    database = Database.get
  
                    deleting_card = false
                    system "clear"
                  when "n"
                    system "clear"
                    next
                  else
                    system "clear"
                    puts "Invalid input"
                    next
                  end
                end
              end
            end
          when "4"
            # EDIT DECK TITLE #
            system "clear"
            puts "Deck: #{edited_deck.title}"
            puts "\n"
            puts "Enter new deck title:"
            new_deck_title = gets.chomp
            edited_deck.title = new_deck_title
            database[deck_number.to_i - 1] = edited_deck.return_deck
            Database.save(database)
            database = Database.get
            system "clear"
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
    next
  else
    system "clear"
    p input
    puts "Invalid input, please try again"
    next
  end
end
