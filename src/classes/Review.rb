require "tty-prompt"
require "tty-box"
require "tty-table"
require "tty-font"

class Review
  attr_accessor :deck

  def initialize(deck)
    @deck = deck
    @score = 0
    @current_card = 0
    @number_of_skips = 0
    @number_of_incorrect_cards = 0
  end

  def start_review(deck = @deck[:cards], first_review = true)
    prompt = TTY::Prompt.new
    
    shuffled_deck = deck.shuffle
    review_after_deck = []

    while @current_card < shuffled_deck.length
      system "clear"
      question_box = TTY::Box.frame(
        align: :center, 
        padding: 3, 
        width: 30, 
        height: 10, 
        title: {
          top_left: "#{@deck[:title]}", 
          bottom_right: "Question"
        }
      ) do
        shuffled_deck[@current_card][:question]
      end

      answer_box = TTY::Box.frame(
        align: :center, 
        padding: 3, 
        width: 30,
        height: 10, 
        title: {
          top_left: "#{@deck[:title]}", 
          bottom_right: "Answer"
        }
      ) do
        shuffled_deck[@current_card][:answer]
      end

      puts "Deck: #{@deck[:title]}"
      puts "\n"
      puts question_box
      puts "\n\n"
      review_options = [
        "Show Answer", 
        "Skip Card",
         "Exit"
        ]
      
      option = prompt.select(
        "Would you like to show answer, skip card or exit?", 
        review_options, 
        cycle: true
      )

      system "clear"
      case option
      when "Show Answer"
      user_viewing_answer = true

      while user_viewing_answer
        puts "Deck: #{@deck[:title]}"
        puts "\n"
        puts answer_box
        puts "\n\n"
        guess_options = ["Correct", "Incorrect"]

        guess = prompt.select(
          "Did you guess this card correctly or incorrectly?", 
          guess_options, 
          cycle: true
        )

        case guess
        when "Correct"
          @score += 1 if first_review == true
          user_viewing_answer = false
          system "clear"
          next
        when "Incorrect"
          # add card to review_after deck #
          @number_of_incorrect_cards += 1
          review_after_deck.push(shuffled_deck[@current_card])
          user_viewing_answer = false
          system "clear"
          next
        else
          system "clear"
          puts "Invalid input"
          next
        end
      end

        # NEXT CARD #
        @current_card += 1
        system "clear"
        next
      when "Skip Card"
        # Move card to back of pile
        @number_of_skips += 1
        skipped_card = shuffled_deck.slice!(@current_card)
        shuffled_deck.push(skipped_card)
        system "clear"
        next
      when "Exit"
        # Break out of start_review method
        return nil
      else
        system "clear"
        puts "Invalid input"
        next
      end
    end

    # If review_after has cards, call start_review method again and pass in review_after_deck
    # else, show statistics
    if review_after_deck.length != 0
      @current_card = 0
      start_review(review_after_deck, false)

    else
      return show_statistics
    end
  end

  def show_statistics
    prompt = TTY::Prompt.new
    table = TTY::Table.new(
      ["Stats","Total"], 
      [
        ["Score", "#{@score}/#{@deck[:cards].length}"], 
        ["Number of skips", " #{@number_of_skips}"], 
        ["Incorrect cards", "#{@number_of_incorrect_cards}"]
      ]
    )
    font = TTY::Font.new(:standard)
    puts font.write("Stats")

    puts "Here are your statistics for this review!"
    puts "\n"
    puts table.render(:ascii, alignments: [:left, :center])
    puts "\n"
    prompt.keypress("Press any key to exit")
    system "clear"
    return nil
  end
end