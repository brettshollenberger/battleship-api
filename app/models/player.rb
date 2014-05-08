class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :boards

  def board_for(game)
    boards.where(game: game).first
  end

  def ships_for(game)
    board_for(game).ships
  end

  def setup?
    return !name.blank?
  end

  def turn?(game)
    game.turn == self.id
  end

  def fire(square)
    square.fire if turn?(square.game)
  end
end
