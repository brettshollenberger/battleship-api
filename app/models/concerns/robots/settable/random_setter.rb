module Robots
  module Settable
    class RandomSetter < Setter
      attr_accessor :current_ship

      def layout
        ships.each do |ship| 
          @current_ship = ship
          randomize_layout
        end
      end

    private
      def randomize_layout
        randomize_squares until fits?
        @current_ship.update(:squares => @random_squares)
      end

      def randomize_squares
        @random_squares = []
        select_random_squares(random_strategy,
                              random_x,
                              random_y,
                              @current_ship.length)
      end

      def fits?
        !@random_squares.nil? &&
          !@random_squares.empty?  && 
          @random_squares.all?(&:empty?) && 
          @random_squares.length == @current_ship.length
      end

      def select_random_squares(strategy, x, y, squares_remaining)
        return if squares_remaining == 0

        @random_square = squares.where(x: x.to_s, y: y.to_s).first
        return randomize_squares unless @random_square

        @random_squares.push(@random_square)
        select_random_squares(strategy, 
                              *self.send(strategy, x, y),
                              squares_remaining-1)
      end

      def random_strategy
        random_inc_or_dec + "_" + random_orientation
      end

      def random_inc_or_dec
        coin_flip ? "increment" : "decrement"
      end

      def random_orientation
        coin_flip ? "horizontal" : "vertical"
      end

      def coin_flip
        Random.rand(0..1) == 1
      end

      def increment_horizontal(x, y)
        [x+1, y]
      end

      def decrement_horizontal(x, y)
        [x-1, y]
      end

      def increment_vertical(x, y)
        [x, integer_to_letter(letter_to_integer(y) + 1)]
      end

      def decrement_vertical(x, y)
        [x, integer_to_letter(letter_to_integer(y) + 1)]
      end

      def rand_in_ten
        Random.rand(1..10)
      end

      def random_x
        rand_in_ten
      end

      def random_y
        integer_to_letter(rand_in_ten)
      end
    end
  end
end
