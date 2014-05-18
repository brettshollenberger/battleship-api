class ShipObserver < ActiveRecord::Observer
  observe :ship

  def after_sunk(ship)
    ship.game.after_ship_sunk
  end
end
