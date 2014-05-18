require 'spec_helper'

describe Game do

  before(:each) do
    @game    = FactoryGirl.create(:game, :with_players)
    @player1 = @game.players.first
    @player2 = @game.players.last
    @board   = @player1.board_for(@game)
  end

  it "is valid" do
    expect(@game).to be_valid
  end

  it "is valid with a state of setup_players" do
    @game.phase = "setup_players"
    expect(@game).to be_valid
  end

  it "is valid with a state of setup_ships" do
    @game.phase = "setup_ships"
    expect(@game).to be_valid
  end

  it "is valid with a state of play" do
    @game.phase = "play"
    expect(@game).to be_valid
  end

  it "is valid with a state of complete" do
    @game.phase = "complete"
    expect(@game).to be_valid
  end

  it "is not valid with some other state" do
    @game.phase = "finished"
    expect(@game).to_not be_valid
  end

  it "has two players" do
    expect(@game.players.length).to eq(2)
  end

  it "has two boards" do
    expect(@game.boards.length).to eq(2)
  end

  it "starts with the first player's turn" do
    expect(@game.turn).to eq(@game.players.first.id)
  end

  it "toggles turns" do
    @game.toggle_turn
    expect(@game.turn).to eq(@game.players.second.id)
    @game.toggle_turn
    expect(@game.turn).to eq(@game.players.first.id)
  end

  describe "Phases of the Game :" do
    it "is in setup_players phase before it has players" do
      @game = FactoryGirl.create(:game)
      expect(@game.phase).to eq("setup_players")
    end

    it "enters setup_ships phase when it has two named players" do
      expect(@game.phase).to eq("setup_ships")
    end

    it "enters play phase when both boards are locked" do
      @game.boards.each(&:set)
      @game.boards.each(&:lock)
      @game.reload
      expect(@game.phase).to eq("play")
    end

    it "is complete when all ships are sunk for a player" do
      @game.boards.each(&:set)
      @game.boards.each(&:lock)
      @game.boards.first.squares.each do |square| 
        square.update(:state => "guessed")
      end
      @game.reload
      expect(@game.phase).to eq("complete")
      expect(@game.winner).to eq(@player2.id)
    end
  end
end
