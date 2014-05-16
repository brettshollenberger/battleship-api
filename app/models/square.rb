class Square < ActiveRecord::Base
  validates_presence_of :x, :y, :board
  # validate :settable_to_ship

  state_machine :state, :initial => :empty do
    state :empty
    state :taken
    state :miss
    state :hit
  end

  belongs_to :board
  belongs_to :game
  belongs_to :ship

  # def settable_to_ship
  #   errors.add(:state, "is already taken") unless settable_to_ship?
  # end

  # def settable_to_ship?
  #   ship_id == nil || ship_id_was == nil || ship_id_was == ship_id
  # end

  def guessed?
    hit? || miss?
  end

  def player
    board.player
  end

  def fire
    update_attribute(:state, :hit)     if taken?
    update_attribute(:state, :miss)    if empty?
  end

  def set_ship(ship)
    update_attribute(:ship, ship)
    update_attribute(:state, "taken")
  end

  def unset_ship
    update_attribute(:ship, nil)
    update_attribute(:state, "empty")
  end

  def settable_to?(ship)
    if self.ship == ship || self.empty?
      true
    else
      ship.add_reassignment_error(self)
      false
    end
  end
end
