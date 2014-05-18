class Game < ActiveRecord::Base
  has_many :squares
  has_many :boards do
    def locked?
      !empty? && all?(&:locked?)
    end
  end

  has_and_belongs_to_many :players, 
    :before_add => :validate_only_two_players,
    :before_add => :add_board,
    :after_add  => :begin_setup_ships_phase do

    def setup?
      self.all? { |player| player.setup? }
    end
  end

  state_machine :phase, :initial => :setup_players do
    state :setup_players
    state :setup_ships
    state :play
    state :complete

    event :players_setup do
      transition :setup_players => :setup_ships
    end

    event :boards_locked do
      transition :setup_ships => :play
    end

    after_transition :setup_players => :setup_ships, :do => :player_ones_turn
  end

  accepts_nested_attributes_for :squares
  accepts_nested_attributes_for :boards

  def after_ship_sunk
    if finished_phase?
      update_attribute(:phase, "complete")
      update_attribute(:winner, find_winner)
    end
  end

  def after_board_locked(board)
    boards_locked if boards.locked?
    toggle_turn   if board.locked?
  end

  def ships
    ships = []
    boards.each { |b| ships << b.ships }
    ships.flatten
  end

  def sync_phase
    update_attribute(:phase, "setup_players") if setup_player_phase?
    update_attribute(:phase, "setup_ships")   if setup_ship_phase?
    update_attribute(:phase, "play")          if play_phase?

    if finished_phase?
      update_attribute(:phase, "finished")
      update_attribute(:winner, find_winner)
    end
  end

  def setup_player_phase?
    !players || !players.setup?
  end

  def setup_ship_phase?
    players.setup? && ships.any?(&:unset?)
  end

  def play_phase?
    !ships.any?(&:unset?) && !finished_phase?
  end

  def finished_phase?
    players(true).any? { |player| player.ships_for(self).all?(&:sunk?) }
  end

  def find_winner
    other_player(players.map { |player| player.ships_for(self).all?(&:sunk?) }.first).id
  end

  def updatable_players
    setup_player_phase? ? players.where(id: turn) : []
  end

  def updatable_ships
    players.find(turn).board_for(self).ships.reject(&:set?)
  end

  def updatable_squares
    players.find(not_turn).board_for(self).squares.reject(&:hit?).reject(&:miss?)
  end

  def initialize_boards
    players.each { |p| boards.create(player: p, game: self) }
  end

  def toggle_turn
    update_attribute :turn, turn == players.first.id ? players.last.id : players.first.id
  end

  def not_turn
    turn == players.first.id ? players.last.id : players.first.id
  end

  def other_player(player)
    self.players.map { |p| p unless p == player }.compact.first
  end

private
  def validate_only_two_players(player)
    self.errors[:players] << only_two_players_error unless players.length <= 2
  end

  def only_two_players_error
    "can only have two players" 
  end

  def add_board(player)
    boards.create(:player => player)
  end

  def begin_setup_ships_phase(player)
    players_setup if players.setup?
  end

  def player_ones_turn
    update_attribute(:turn, players.first.id)
  end
end
