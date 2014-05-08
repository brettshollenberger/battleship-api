class Player < ActiveRecord::Base
  has_and_belongs_to_many :games
  has_many :boards

  def board_for(game)
    boards.where(game: game).first
  end

  def setup?
    return !name.blank?
  end
end
