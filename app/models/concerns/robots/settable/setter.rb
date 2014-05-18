module Robots
  module Settable
    class Setter
      include SquareConverter
      attr_accessor :owner
      delegate :ships, :squares, :to => :owner

      def initialize(owner)
        @owner = owner
      end

      def owner
        @owner
      end
    end
  end
end
