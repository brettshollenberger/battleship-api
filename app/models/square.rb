class Square < ActiveRecord::Base
  validates_presence_of :x, :y, :board

  state_machine :state, :initial => :empty do
    state :empty
    state :taken
    state :guessed
    state :hit
  end

  belongs_to :board
  belongs_to :game
  belongs_to :ship

  def fire
    update!(state: :hit)     if taken?
    update!(state: :guessed) if empty?
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
    self.ship == ship || self.empty?
  end
end
