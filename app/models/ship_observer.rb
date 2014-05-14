class ShipObserver < ActiveRecord::Observer
  observe :ship

  def after_update(ship)
    ship.board.reload && ship.board.ships.reload
    ship.board.update_attribute(:state, "lockable") if ship.board.ships.set?
    ship.board.update_attribute(:state, "unlocked") if !ship.board.ships.set?
  end
end
