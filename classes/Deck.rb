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

  def edit_card(card, index)
    @cards[index] = card
    return @cards
  end

  def delete_card(card, index)
    @cards.delete_at(index)
    return @cards
  end

  def return_deck
    return { title: @title, cards: @cards }
  end
end