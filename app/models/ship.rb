class Ship < ActiveRecord::Base
  belongs_to :board
  has_many :squares

  validates_presence_of :board
  validates :kind, :inclusion => { :in => ["aircraft carrier", "battleship", 
                                           "submarine", "destroyer", "patrol boat"] }

  validates :state, :inclusion => { :in => ["unset", "set", "hit", "sunk"] }

  def game
    board.game
  end

  def unset
    write_attribute(:state, "unset") && save
  end

  def unset?
    state == "unset"
  end

  def set(*sqs)
    if sqs.length == self.length && board.squares_settable?(*sqs)
      write_attribute(:state, "set") && save
      return true
    end
  end

  def set?
    state == "set"
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
