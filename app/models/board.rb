class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  has_many :squares
  has_many :ships do
    def set?
      self.all? { |ship| ship.set? }
    end
  end

  after_create :setup

  def setup
    setup_squares
    setup_ships
  end

  def setup_squares
    ("A".."J").each do |l|
      (1..10).each do |n|
        squares.create(x: n, y: l)
      end
    end
  end

  def setup_ships
    ["aircraft carrier", "battleship", "submarine", "destroyer", "patrol boat"].each do |kind|
      ships.create(kind: kind)
    end
  end

  def get(y, x)
    squares.where(x: x.to_s, y: y.to_s).first
  end
end
