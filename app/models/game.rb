class Game < ActiveRecord::Base
  has_many :boards
  has_many :players
  validates :phase, :inclusion => { :in => ["setting_ships", "play", "complete"] }

  after_create :setup

  def setup
    setup_boards
  end

  def setup_boards
    2.times { |n| boards.create }
  end
end
