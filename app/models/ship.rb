class Ship < ActiveRecord::Base
  belongs_to :board
  has_many :squares

  validates_presence_of :board
  validates :kind, :inclusion => { :in => ["aircraft carrier", "battleship", 
                                           "submarine", "destroyer", "patrol boat"] }

  validates :state, :inclusion => { :in => ["unset", "set", "hit", "sunk"] }

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
