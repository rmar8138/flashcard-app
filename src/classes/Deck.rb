class Deck
  attr_accessor :title
  attr_reader :cards

  def initialize(title, cards = [])
    @title = title
    @cards = cards
  end

  def add_card
    prompt = TTY::Prompt.new
  
    puts "Deck: #{@title}"
    puts "\n\n"
    puts "Card #{@cards.length + 1}"
    puts "\n\n"
    question = prompt.ask("Enter the question:")
    answer = prompt.ask("Enter the answer:")

    @cards.push({ question: question, answer: answer })
    return @cards
  end

  def edit_card(type, card_number)
    prompt = TTY::Prompt.new
    puts "Card #{card_number + 1}:"
    puts "\n"
    puts "#{type.capitalize}: #{@cards[card_number][type.to_sym]}"
    puts "\n"
    text = prompt.ask("Enter a new #{type}:")

    case type
    when "question"
      @cards[card_number][:question] = text
    when "answer"
      @cards[card_number][:answer] = text
    else
      return nil
    end
    return @cards
  end

  def delete_card(indexes)
    new_deck = @cards.reject.with_index do |card, index|
      indexes.include?(index)
    end

    @cards = new_deck
    return @cards
  end

  def return_deck
    return { title: @title, cards: @cards }
  end
end
