class Player < ActiveRecord::Base
  after_initialize :setup_brain
  has_and_belongs_to_many :games
  has_many :boards

  validates_presence_of :name

  def setup_brain
    unless brain.nil?
      Player.send :include, ("Robots::" + brain.to_s.classify).constantize
      self.send(:set_robot_attributes)
    end
  end

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

  def player_number(game)
    @other_player = game.other_player(self)
    @other_player.id > self.id ? "Player 1" : "Player 2"
  end
end
