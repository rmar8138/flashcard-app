class Review
  attr_accessor :deck

  def initialize(deck)
    @deck = deck
    @score = 0
    @current_card = 0
  end

  def start_review
    shuffled_deck = @deck[:cards].shuffle
    review_after = []

    while @current_card < shuffled_deck.length
      system "clear"

      puts "Deck: #{@deck[:title]}"
      puts "\n"
      puts "To exit the review at any time, hit the esc key and press enter/return"
      puts "\n\n"
      puts "Question: #{shuffled_deck[@current_card][:question]}"
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
          puts "Question: #{shuffled_deck[@current_card][:question]}"
          puts "\n\n"
          puts "Answer: #{shuffled_deck[@current_card][:answer]}"
          puts "\n\n"
          puts "Enter the number to the left of the appropriate outcome"
          puts "\n"
          puts "(1) Correct\n(2) Incorrect"
          input = gets.chomp
          case input
          when "1"
            @score += 1
            user_viewing_answer = false
            next
          when "2"
            # add card to review_after deck #
            review_after.push(shuffled_deck[@current_card])
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
        skipped_card = shuffled_deck.slice!(@current_card)
        shuffled_deck.push(skipped_card)
        system "clear"
        next
      else
        system "clear"
        puts "Invalid input"
        next
      end
    end

    # IF review_after has cards, shuffled deck = review_after and review these, repeat.
    # else, show statistics

    if review_after.length > 0
      p review_after
    else
      show_statistics
    end
  end

  def show_statistics
    puts "Statistics!"
    puts "Score: #{@score}/#{@deck[:cards].length}"
  end
end

# show first card
# user either enters 1. show answer, 2. skip
  # if show answer
  # on showing answer, user either enters 1. correct, 2. incorrect
    # if correct, add 1 to score and move to next card
    # if incorrect, move card to new array for later review
  #if skip
    # move card to back of array and move to next question

# when all cards in initial review have been completed, review any incorrect cards and repeat. do not add to score