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
  has_one :ship

  def fire
    update!(state: :hit)     if taken?
    update!(state: :guessed) if empty?
  end
end
