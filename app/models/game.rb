class Game < ActiveRecord::Base
  has_many :boards
  has_many :squares
  has_and_belongs_to_many :players do
    def setup?
      self.all? { |player| player.setup? }
    end
  end

  state_machine :phase, :initial => :setup_players do
    state :setup_players
    state :setup_ships
    state :play
    state :complete
  end

  after_create :setup

  def setup
    initialize_players
    initialize_boards
    initialize_turn
  end

  def after_ship_sunk
    if finished_phase?
      update_attribute(:phase, "finished")
      update_attribute(:winner, find_winner)
    end
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
    players.any? { |player| player.ships_for(self).all?(&:sunk?) }
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

  def initialize_players
    2.times do |n|
      @p = Player.create
      @gp = GamesPlayers.create(game: self, player: @p)
    end
  end

  def initialize_boards
    players.each { |p| boards.create(player: p, game: self) }
  end

  def initialize_turn
    update_attribute(:turn, players.first.id)
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
end
