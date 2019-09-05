class Deck
  attr_accessor :title
  attr_reader :cards

  def initialize(title, cards = [])
    @title = title
    @cards = cards
  end

  def add_card(card)
    @cards.push(card)
    return @cards
  end

  def edit_card(what_to_edit, changes, index)
    case what_to_edit
    when "question"
      @cards[index][:question] = changes
    when "answer"
      @cards[index][:answer] = changes
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