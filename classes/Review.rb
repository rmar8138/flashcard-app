require "tty-box"

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
    
    shuffled_deck = deck.shuffle
    review_after_deck = []
    p shuffled_deck
    p review_after_deck

    while @current_card < shuffled_deck.length
      system "clear"
      question_box = TTY::Box.frame(align: :center, padding: 3, width: 30, height: 10, title: {top_left: "#{@deck[:title]}", bottom_right: "Question"}) do
        "#{shuffled_deck[@current_card][:question]}"
      end

      answer_box = TTY::Box.frame(align: :center, padding: 3, width: 30, height: 10, title: {top_left: "#{@deck[:title]}", bottom_right: "Answer"}) do
        "#{shuffled_deck[@current_card][:answer]}"
      end

      puts "Deck: #{@deck[:title]}"
      puts "\n"
      puts "To exit the review at any time, hit the esc key and press enter/return"
      puts "\n\n"

      puts question_box
      puts "\n\n"
      puts "Would you like to show answer or skip? Enter number to the left"
      puts "(1) Show answer\n(2) Skip card"
      input = gets.chomp

      system "clear"
        case input
        when "1"
        user_viewing_answer = true
        while user_viewing_answer
          puts "Deck: #{@deck[:title]}"
          puts "\n"
          puts "To exit the review at any time, hit the esc key and press enter/return"
          puts "\n\n"
          puts answer_box
          puts "\n\n"
          puts "Enter the number to the left of the appropriate outcome"
          puts "\n"
          puts "(1) Correct\n(2) Incorrect"
          input = gets.chomp
          case input
          when "1"
            @score += 1 if first_review == true
            user_viewing_answer = false
            next
          when "2"
            # add card to review_after deck #
            @number_of_incorrect_cards += 1
            review_after_deck.push(shuffled_deck[@current_card])
            user_viewing_answer = false
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
      when "2"
        # Move card to back of pile
        @number_of_skips += 1
        skipped_card = shuffled_deck.slice!(@current_card)
        shuffled_deck.push(skipped_card)
        system "clear"
        next
      when "\e"
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
    puts "Here are your statistics for this review!"
    puts "\n"
    puts "Score: #{@score}/#{@deck[:cards].length}"
    puts "Number of skips: #{@number_of_skips}"
    puts "Number of incorrectly guessed cards: #{@number_of_incorrect_cards}"
    puts "\n"
    puts "Enter any key to return to menu"
    input = gets.chomp
    system "clear"
    return nil
  end
end