require "tty-prompt"
require "tty-box"
require "tty-table"
require_relative "./classes/Deck"
require_relative "./classes/Review"
require_relative "./modules/Database"
require_relative "./methods/methods"

database = Database.get
prompt = TTY::Prompt.new

welcome_menu_open = true

while welcome_menu_open
  ##################
  # WELCOME SCREEN #
  ##################

  puts "Welcome to the terminal flash card app!"
  puts "\n\n"
  input = prompt.select("Please select an option:", ["Review", "Add Deck", "Edit Deck", "Settings", "Exit"], cycle: true)
  case input
  when "Review"
    ###############
    # DECK REVIEW #
    ###############

    system "clear"

    review_menu_open = true
    if database.length == 0
      system "clear"
      puts "No decks to review! Please make a deck first"
      puts "\n"

      review_menu_open = false
      next
    end

    while review_menu_open
      deck = prompt.select("Which deck would you like to review?", per_page: 8, cycle: true) do |menu|
        menu.enum "."
        count = 0
        for deck in database
          menu.choice({deck[:title] => count})
          count += 1
        end
        menu.choice("Return to menu")
      end

      if deck == "Return to menu"
        system "clear"
        review_menu_open = false
        next
      end

      # START REVIEW! #
      review = Review.new(database[deck])
      review.start_review

      review_menu_open = false
      next
    end


  when "Add Deck"
    ############
    # ADD DECK #
    ############

    system "clear"

    title = prompt.ask("Please enter a title for the deck:")

    new_deck = Deck.new(title)

    system "clear"

    

    finished_adding_cards = false
    until finished_adding_cards

      new_card = create_card(new_deck)

      new_deck.add_card(new_card)

      add_another_card_prompt_open = true
      while add_another_card_prompt_open
        add_another = prompt.select("Add another card?", [{ Yes: true }, { No: false }])

        case add_another
        when true
          system "clear"
          add_another_card_prompt_open = false
        when false
          add_another_card_prompt_open = false
          finished_adding_cards = true
          system "clear"
        else
          puts "Invalid input"
        end
      end

    end

    puts "New deck created!"
    puts "#{new_deck.title}: #{new_deck.cards.length} card(s)"
    puts "\n"
    prompt.keypress("Press any key to save and return to menu")

    database.push(new_deck.return_deck)
    Database.save(database)

    system "clear"
    next
  when "Edit Deck"
    #############
    # EDIT DECK #
    #############

    system "clear"
    edit_menu_open = true

    while edit_menu_open
      deck = prompt.select("Which deck would you like to review?", per_page: 8, cycle: true) do |menu|
        menu.enum "."
        count = 0
        for deck in database
          menu.choice({deck[:title] => count})
          count += 1
        end
        menu.choice("Return to menu")
      end

      system "clear"
      edited_deck = Deck.new(database[deck][:title], database[deck][:cards])
      editing_deck = true

      while editing_deck
        puts "Deck: #{edited_deck.title}"
        puts "Cards: #{edited_deck.cards.length} card(s)"
        puts "\n"

        edit_options = ["Add Card", "Edit Card", "Delete Card", "Edit Deck Title", "Delete Deck", "Exit"]
        option = prompt.select("Please select an option:", edit_options, cycle: true, per_page: 10)

        case option
        when "Add Card"
          # ADD NEW CARD TO EXISTING DECK #
          system "clear"

          add_card(edited_deck)
          database[deck_number.to_i - 1] = edited_deck.return_deck
          Database.save(database)
          database = Database.get

          system "clear"
          next
        when "Edit Card"
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
        when "Delete Card"
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
        when "Edit Deck Title"
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
        when "Delete Deck"
          # DELETE DECK #
          system "clear"
          puts "Deck: #{edited_deck.title}"
          puts "\n"
          puts "Are you sure you want to delete this deck? (y/n)"
          input = gets.chomp

          case input
          when "y"
            database.delete_at(deck_number.to_i - 1)
            system "clear"

            Database.save(database)
            database = Database.get
            system "clear"

            editing_deck = false
            next
          when "n"
            system "clear"
            next
          else
            system "clear"
            puts "Invalid input"
            next
          end

        when "Exit"
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

  when "Settings"
    ############
    # SETTINGS #
    ############

    system "clear"
    puts "Settings!"

    welcome_menu_open = false
  when "Exit"
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
