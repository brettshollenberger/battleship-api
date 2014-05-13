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
        squares.create(x: n, y: l, game: game)
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

  def squares_settable?(*sqs)
    sqs.flatten.all?(&:empty?) && same?(*sqs, :board) && this_board?(*sqs) && contiguous?(*sqs)
  end

  def contiguous?(*sqs)
    numerically_sequential?(*sqs) && same?(*sqs, :y) || 
    alphabetically_sequential?(*sqs) && same?(*sqs, :x)
  end

  def sequential?(nums)
    nums.sort.inject { |p, n| n == p + 1 ? n : -1 } != -1
  end

  def numerically_sequential?(sqs)
    sequential?(sqs.map { |sq| sq.x.to_i })
  end

  def alphabetically_sequential?(sqs)
    @alph = Hash[*("A".."Z").zip(1..26).flatten]
    sequential?(sqs.map { |sq| @alph[sq.y] })
  end

  def this_board?(sqs)
    sqs.map { |sq| sq.board }.uniq.first == self
  end

  def same?(sqs, key)
    sqs.map { |sq| sq.send(key) }.uniq.length == 1
  end
end
