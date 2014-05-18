class Ship < ActiveRecord::Base
  before_save :update_state
  before_save :notify_if_sunk

  validates_presence_of :board
  validate :validate_contiguous_squares
  validate :validate_squares_on_the_same_board
  validate :validate_number_of_squares

  belongs_to :board
  has_many :squares, :before_remove => :empty_square do
    include SquareSubset
  end

  accepts_nested_attributes_for :squares

  state_machine :state, :initial => :unset do
    state :unset
    state :set
    state :hit
    state :sunk
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

  def update_state
    write_attribute(:state, "unset") and return if squares.empty?
    write_attribute(:state, "set") and return   unless squares.empty? || squares.any?(&:hit?) 
    write_attribute(:state, "sunk") and return if squares.all?(&:hit?)
    write_attribute(:state, "hit") and return  if squares.any?(&:hit?)
  end

  def notify_if_sunk
    notify_observers :after_sunk if sunk?
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

  # def set(*sqs)
  #   squares.reload
  #   if board.settable?(ship: self, squares: sqs.flatten)
  #     unset
  #     clear_setting_errors
  #     update_attribute(:state, "set")
  #     sqs.flatten.each { |sq| sq.set_ship(self) }
  #   end
  # end

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

private
  def empty_square(square)
    square.update_attribute(:ship_id, nil)
  end

  def validate_contiguous_squares
    self.errors[:squares] << contiguous_squares_error unless 
      squares.empty? || squares.contiguous?
  end

  def validate_squares_on_the_same_board
    self.errors[:squares] << squares_on_the_same_board_error unless 
      squares.empty? || squares.same?(:board)
  end

  def validate_number_of_squares
    self.errors[:squares] << number_of_squares_error unless 
      squares.empty? || squares.length == length
  end

  def contiguous_squares_error
    "must be contiguous"
  end

  def squares_on_the_same_board_error
    "must be on the same board"
  end

  def number_of_squares_error
    "must be set to #{length.to_words} squares" 
  end
end
