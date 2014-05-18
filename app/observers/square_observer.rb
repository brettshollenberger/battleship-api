class SquareObserver < ActiveRecord::Observer
  observe :square

  def after_hit(square)
    square.ship.after_square_hit(square)
  end
end
