class Deck
  attr_accessor :title
  attr_reader :cards

  def initialize(title)
    @title = title
    @cards = []
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
end