class Board < ActiveRecord::Base
  delegate :set, :to => :setter_proxy

  after_create :setup
  before_save :save_ships
  before_save :update_state
  after_save :send_notifications

  belongs_to :game
  belongs_to :player
  has_many :squares
  has_many :ships do
    def set?
      self.all? { |ship| ship.set? }
    end
  end

  accepts_nested_attributes_for :ships

  validates_associated :ships

  state_machine :state, :initial => :unlocked do
    state :unlocked
    state :lockable
    state :locked

    event :set do
      transition :unlocked => :lockable
    end

    event :lock do
      transition :lockable => :locked
    end
  end

private
  def send_notifications
    notify_locked
  end

  def notify_locked
    notify_observers :after_locked if locked?
  end

  def setter_proxy
    Robots::Settable::SetterProxy.new({owner: self})
  end

  def setup
    setup_squares
    setup_ships
  end

  def setup_squares
    ("A".."J").each do |l|
      (1..10).each do |n|
        squares.create(x: n, y: l, game: game)
      end
    end
  end

  def setup_ships
    ["aircraft carrier", "battleship", "submarine", "destroyer", "patrol boat"].each do |kind|
      ships.create(kind: kind)
    end
  end

  def save_ships
    ships.each(&:save)
  end

  def update_state
    unless locked?
      write_attribute(:state, "lockable") if ships.set?
      write_attribute(:state, "unlocked") unless ships.set?
    end
  end

  def valid_state_transition?(value)
    valid_transition_to_unlocked?(value) || 
      valid_transition_to_lockable?(value) ||
        valid_transition_to_locked?(value)
  end

  def valid_transition_to_unlocked?(value)
    value == "unlocked"
  end

  def valid_transition_to_lockable?(value)
    unlocked? && value == "lockable"
  end

  def valid_transition_to_locked?(value)
    lockable? && value == "locked"
  end
end
