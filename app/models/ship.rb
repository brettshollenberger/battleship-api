class Ship < ActiveRecord::Base
  validates_presence_of :board

  validates :kind, :inclusion => { :in => ["aircraft carrier", "battleship", 
                                           "submarine", "destroyer", "patrol boat"] }

  validates :state, :inclusion => { :in => ["unset", "set", "hit", "sunk"] }

  validate :contiguous_squares

  belongs_to :board

  has_many :squares do
    def contiguous?
      empty? ||
        numerically_sequential? && same?(:y) || 
        alphabetically_sequential? && same?(:x)
    end

    def sequential?(nums)
      nums.sort.inject { |p, n| n == p + 1 ? n : -1 } != -1
    end

    def numerically_sequential?
      sequential?(self.map { |sq| sq.x.to_i })
    end

    def alphabetically_sequential?
      @alph = Hash[*("A".."Z").zip(1..26).flatten]
      sequential?(self.map { |sq| @alph[sq.y] })
    end

    def same?(key)
      self.map { |sq| sq.send(key) }.uniq.length == 1
    end
  end

  accepts_nested_attributes_for :squares

  def contiguous_squares
    self.errors[:squares] << "must be contiguous" unless squares.contiguous?
  end

  def sync
    squares.reload
    update_attribute(:state, "hit")  if squares.any?(&:hit?)
    update_attribute(:state, "sunk") if squares.all?(&:hit?)
  end

  def game
    board.game
  end

  def unset
    squares.reload && squares.each(&:unset_ship)
    update_attribute(:state, "unset")
  end

  def unset?
    state == "unset"
  end

  def sunk?
    state == "sunk"
  end

  def set(*sqs)
    squares.reload
    if board.settable?(ship: self, squares: sqs.flatten)
      unset
      clear_setting_errors
      update_attribute(:state, "set")
      sqs.flatten.each { |sq| sq.set_ship(self) }
    end
  end

  def set?
    state == "set"
  end

  def correct_length?(squares)
    unless self.length == squares.length
      add_setting_error(:length)
      false
    else
      true
    end
  end

  def turn?
    unless board.player.turn?(game.reload)
      add_setting_error(:out_of_turn)
      false
    else
      true
    end
  end

  def clear_setting_errors
    errors.delete(:squares)
  end

  def add_setting_error(error)
    errors.add(:squares, self.send(error.to_s + "_error"))
  end

  def out_of_turn_error
    "cannot be set out of turn"
  end

  def length_error
    "can only be assigned to #{length.to_words} squares"
  end

  def reassignment_error(square)
    "square #{square.id} is already taken"
  end

  def add_reassignment_error(square)
    errors.add(:squares, reassignment_error(square))
  end

  state_machine :kind do
    state "aircraft carrier" do
      def length
        5
      end
    end

    state "battleship" do
      def length
        4
      end
    end

    state "submarine" do
      def length
        3
      end
    end

    state "destroyer" do
      def length
        3
      end
    end

    state "patrol boat" do
      def length
        2
      end
    end
  end
end
