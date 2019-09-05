require "tty-prompt"
require "tty-font"
require "tty-box"
require "tty-table"
require_relative "./classes/Deck"
require_relative "./classes/Review"
require_relative "./modules/Database"
require_relative "./methods/methods"

begin
  database = Database.get
  prompt = TTY::Prompt.new
  # QUICK REVIEW #
  # Users can do a quick review if they know the name of the deck they want to review

  if ARGV.length != 0
    if ARGV[0] == "--review"
      unless ARGV[1] 
        abort("Please enter a deck title as an argument")
      else
        database.each do |deck|
          if deck[:title] == ARGV[1]
            p deck[:title]
            quick_review = Review.new(deck)
            quick_review.start_review
            exit
          end
        end
        
        abort("Deck not found!")
      end
    elsif ARGV[0] == "--kahoot"
      pid = fork{ exec "afplay", "./assets/song.mp3" }
    else
      abort("Unknown option")
    end
  end

  welcome_menu_open = true

  while welcome_menu_open
    ##################
    # WELCOME SCREEN #
    ##################
    system "clear"
    font = TTY::Font.new(:standard)
    if ARGV[0] == "--kahoot"
      puts font.write("KAHOOT")
    else
      puts font.write("Flashcard App")
    end

    puts "Welcome to the terminal flash card app!"
    puts "\n"
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
        puts font.write("Review")
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
      puts font.write("Add Deck")
      title = prompt.ask("Please enter a title for the deck:") do |question|
        question.validate(/[A-Za-z0-9\s\.\:\,\-\_]/, 'Only letters, numbers, spaces, dashes, underscores, periods, colons and commas allowed. No white space at the start of title.')
      end

      new_deck = Deck.new(title)

      system "clear"

    
      finished_adding_cards = false
      until finished_adding_cards
        puts font.write("Add Deck")
        new_card = create_card(new_deck)
        new_deck.add_card(new_card)

        add_another_card_prompt_open = true
        while add_another_card_prompt_open
          add_another = prompt.select("Add another card?", [{ Yes: true }, { No: false }], cycle: true)

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

      puts font.write("Add Deck")
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
        puts font.write("Edit Deck")
        deck = prompt.select("Which deck would you like to review? (Select last option 'Exit' to return to menu)\n", per_page: 8, cycle: true) do |menu|
          menu.enum "."
          count = 0
          for deck in database
            menu.choice({deck[:title] => count})
            count += 1
          end
          menu.choice("Exit")
        end

        if deck == "Exit"
          system "clear"
          edit_menu_open = false
          next
        end

        system "clear"
        edited_deck = Deck.new(database[deck][:title], database[deck][:cards])
        editing_deck = true

        while editing_deck
          puts font.write("Edit Deck")
          puts "Deck: #{edited_deck.title}"
          puts "Cards: #{edited_deck.cards.length} card(s)"
          puts "\n"

          edit_options = ["Add Card", "Edit Card", "Delete Card", "Edit Deck Title", "Delete Deck", "Exit"]
          option = prompt.select("Please select an option:", edit_options, cycle: true, per_page: 10)

          case option
          when "Add Card"
            # ADD NEW CARD TO EXISTING DECK #
            system "clear"
            puts font.write("Edit Deck")
            new_card = create_card(edited_deck)
            edited_deck.add_card(new_card)

            database[deck] = edited_deck.return_deck
            Database.save(database)
            database = Database.get

            system "clear"
            next
          when "Edit Card"
            # EDIT EXISTING CARD IN EXISTING DECK #
            system "clear"
            puts font.write("Edit Deck")

            if edited_deck.cards.length == 0
              prompt.keypress("No cards in this deck to edit! Press any key to go back")
              system "clear"
              next
            end

            card_number = prompt.select("Which card would you like to edit?", per_page: 8, cycle: true) do |menu|
              menu.enum "."
              count = 0
              for card in edited_deck.cards
                menu.choice({card[:question] => count})
                count += 1
              end
              menu.choice("Exit")
            end

            if card_number == "Exit"
              system "clear"
              next
            elsif card_number.to_i < 0 || card_number.to_i > edited_deck.cards.length
              system "clear"
              puts "Invalid input"
              next
            else
              system "clear"
              user_editing_card = true

              while user_editing_card
                puts font.write("Edit Deck")
                puts "Card #{card_number + 1}"
                puts "\n"
                puts "Question: #{edited_deck.cards[card_number][:question]}"
                puts "Answer: #{edited_deck.cards[card_number][:answer]}"
                puts "\n"
                edit_card_options = ["Edit Question", "Edit Answer", "Exit"]

                option = prompt.select("Would you like to edit the question, the answer, or exit?", edit_card_options)

                case option
                when "Edit Question"
                  # EDIT QUESTION #
                  system "clear"
                  puts font.write("Edit Deck")
                  puts "Card #{card_number + 1}:"
                  puts "\n"
                  puts "Question: #{edited_deck.cards[card_number][:question]}"
                  puts "\n"
                  new_question = prompt.ask("Enter a new question:")

                  edited_deck.edit_card("question", new_question, card_number)

                  Database.save(database)
                  database = Database.get
                  system "clear"
                  next
                when "Edit Answer"
                  # EDIT ANSWER #
                  system "clear"
                  puts font.write("Edit Deck")
                  puts "Card #{card_number + 1}:"
                  puts "\n"
                  puts "Answer: #{edited_deck.cards[card_number][:answer]}"
                  puts "\n"
                  new_answer = prompt.ask("Enter a new answer:")

                  edited_deck.edit_card("answer", new_answer, card_number)

                  Database.save(database)
                  database = Database.get
                  system "clear"
                when "Exit"
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
              puts font.write("Edit Deck")
              prompt.keypress("No cards in this deck to delete! Press any key to go back")
              system "clear"
              next
            else
              system "clear"

              deleting_cards = true

              while deleting_cards
                puts font.write("Edit Deck")
                card_numbers = prompt.multi_select("Which cards would you like to delete? To exit, unselect all cards and hit enter\n", per_page: 8, cycle: true, echo: false) do |menu|
                  menu.enum "."
                  count = 0
                  for card in edited_deck.cards
                    menu.choice({card[:question] => count})
                    count += 1
                  end
                end

                if card_numbers.length == 0
                  system "clear"
                  deleting_cards = false
                  next
                else
                  delete_card = prompt.select("Are you sure you want to delete this/these card(s)", [{ Yes: true }, { No: false }], cycle: true)

                  if delete_card
                    edited_deck.delete_card(card_numbers)

                    database[deck] = edited_deck.return_deck
                    Database.save(database)
                    database = Database.get
                    
                    system "clear"
                    deleting_cards = false
                    next
                  else
                    system "clear"
                    deleting_cards = false
                    next
                  end
                end
              end
            end
          when "Edit Deck Title"
            # EDIT DECK TITLE #
            system "clear"
            puts font.write("Edit Deck")
            puts "Deck: #{edited_deck.title}"
            puts "\n"

            new_deck_title = prompt.ask("Enter new deck title:") do |question|
              question.validate(/[A-Za-z0-9\s\.\:\,\-\_]/, 'Only letters, numbers, spaces, dashes, underscores, periods, colons and commas allowed. No white space at the start of title.')
            end
            edited_deck.title = new_deck_title
            database[deck] = edited_deck.return_deck

            Database.save(database)
            database = Database.get
            system "clear"

          when "Delete Deck"
            # DELETE DECK #
            system "clear"
            puts font.write("Edit Deck")
            puts "Deck: #{edited_deck.title}"
            puts "\n"

            option = prompt.select("Are you sure you want to delete this deck?", [{ Yes: true }, { No: false }], cycle: true)

            case option
            when true
              database.delete_at(deck)

              Database.save(database)
              database = Database.get
              system "clear"

              editing_deck = false
              next
            when false
              system "clear"
              next
            else
              system "clear"
              puts "Invalid input"
              next
            end
          when "Exit"
            system "clear"
            editing_deck = false
            next
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
      puts font.write("Settings")
      puts "Settings! Coming soon..."
      prompt.keypress("Press any key to return to menu")
      system "clear"
      next
    when "Exit"
      system "clear"
      puts font.write("Cya!")

      welcome_menu_open = false
      next
    else
      system "clear"
      p input
      puts "Invalid input, please try again"
      next
    end
  end

  pid = fork{ exec "killall afplay" } if ARGV[0] == "--kahoot"
rescue => exception
  # If the database.json file is empty, the program will not be able to load in the database
  # This displays an error message instead of crashing the program
  puts "Ooops, there was an error :("
  puts "There could be something wrong with the database file, maybe you have an empty database.json file?"
  puts "If you do have an empty database.json file, delete that file and try again!"
end
