class Game < ActiveRecord::Base
  attr_accessor :private_controls

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

    after_transition :on => :play, :do => :toggle_turn
  end

  after_create :setup

  def setup
    initialize_players
    initialize_boards
    initialize_turn
  end

  def merged_controls(controls)
    (default_controls << controls).flatten
  end

  def ships
    ships = []
    boards.each { |b| ships << b.ships }
    ships.flatten
  end

  def sync
    sync_phase
  end

  def sync_phase
    update_attribute(:phase, "setup_ships") if setup_ship_phase?
    update_attribute(:phase, "play")        if play_phase?
  end

  def setup_ship_phase?
    players.setup? && ships.any?(&:unset?)
  end

  def play_phase?
    ships.all?(&:set?)
  end

  def controls
    sync_phase
    set_controls
    @private_controls
  end

  def set_controls
    set_default_controls
    set_player_controls if phase == "setup_players"
    set_ship_controls if phase == "setup_ships"
    set_turn_controls if phase == "play"
  end

  def set_default_controls
    @private_controls = [{rel: "post", item: "game"}]
  end

  def set_player_controls
    players.each do |player| 
      @private_controls << edit_association_control(player) unless player.setup?
    end
  end

  def set_ship_controls
    player = players.find(turn)
    ships  = player.board_for(self).ships
    return toggle_turn && set_ship_controls if ships.set?

    ships.each do |ship|
      @private_controls << edit_association_control(ship)
    end
  end

  def set_turn_controls
    player  = players.find(not_turn)
    squares = player.board_for(self).squares.reject(&:guessed?)

    squares.each do |square|
      @private_controls << edit_association_control(square)
    end
  end

  def edit_association_control(association)
    {rel: "edit", association: association}
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
    update_attribute :turn, turn == players.first.id ? players.second.id : players.first.id
  end

  def not_turn
    turn == players.first.id ? players.second.id : players.first.id
  end
end
