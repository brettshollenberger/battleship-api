class Square < ActiveRecord::Base
  before_save :update_state
  validates_presence_of :x, :y, :board

  state_machine :state, :initial => :empty do
    state :empty
    state :taken
    state :miss
    state :hit
  end

  belongs_to :board
  belongs_to :game
  belongs_to :ship

  def update_state
    write_attribute(:state, "taken") if ship
    write_attribute(:state, "empty") unless ship
  end

  def guessed?
    hit? || miss?
  end

  def player
    board.player
  end

  def fire
    update_attribute(:state, :hit)  if taken?
    update_attribute(:state, :miss) if empty?
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
