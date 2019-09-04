class Review
  attr_accessor :deck

  def initialize(deck)
    @deck = deck
    @score = 0
    @current_card = 0
  end

  def start_review
    puts "Deck: #{@deck[:title]}"
    puts "\n"
    puts "To exit the review at any time, hit the esc key and press enter/return"
    
    review_in_session = true

    while review_in_session
      

    end
  end

  def show_statistics

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