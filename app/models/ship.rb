class Ship < ActiveRecord::Base
  belongs_to :board
  belongs_to :square

  validates_presence_of :board
  validates :type, :inclusion => { :in => ["aircraft carrier", "battleship", "submarine", 
                                           "destroyer", "patrol boat"] }

  validates :state, :inclusion => { :in => ["unset", "set", "hit", "sunk"] }

  state_machine :type do
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
