class Game < ActiveRecord::Base
  has_many :boards
  has_and_belongs_to_many :players
  validates :phase, :inclusion => { :in => ["setup_players", "setup_ships", "play", 
                                            "complete"] }

  state_machine :phase, :initial => :setup_players do
    state :setup_players
    state :setup_ships
    state :play
    state :complete
  end

  after_create :setup

  def setup
    setup_players
    setup_boards
    setup_turn
  end

  def default_controls
    [{rel: "post", item: "game"}]
  end

  def merged_controls(controls)
    (default_controls << controls).flatten
  end

  def controls
    players.each do |player|
      return merged_controls([{rel: "edit", association: player}]) unless player.setup?
    end
  end

  def setup_players
    2.times do |n|
      @p = Player.create
      @gp = GamesPlayers.create(game: self, player: @p)
    end
  end

  def setup_boards
    players.each { |p| boards.create(player: p, game: self) }
  end

  def setup_turn
    write_attribute(:turn, players.first.id)
  end

  def toggle_turn
    write_attribute :turn, turn == players.first.id ? players.second.id : players.first.id
  end
end
