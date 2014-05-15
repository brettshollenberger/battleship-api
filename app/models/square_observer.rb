class SquareObserver < ActiveRecord::Observer
  observe :square

  def after_update(square)
    square.ship.sync if square.ship
    square.board.game.sync if square.ship && square.ship.sunk?
  end
end
