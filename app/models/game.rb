class Game < ActiveRecord::Base
  has_many :boards
  has_and_belongs_to_many :players
  validates :phase, :inclusion => { :in => ["setting_ships", "play", "complete"] }

  after_create :setup

  def setup
    setup_players
    setup_boards
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
end
