require 'spec_helper'

describe Game do

  before(:each) do
    @game    = FactoryGirl.create(:game)
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

  # it "is complete when all ships are sunk for a player" do
  #   @ship          = @board.ships[4]
  #   @ship2         = @board.ships[3]
  #   @ship3         = @board.ships[2]
  #   @ship4         = @board.ships[1]
  #   @ship5         = @board.ships[0]
  #   @sq1           = @board.squares[0]
  #   @sq2           = @board.squares[1]
  #   @sq3           = @board.squares[2]
  #   @sq4           = @board.squares[3]
  #   @sq5           = @board.squares[4]
  #   @sq6           = @board.squares[5]
  #   @sq7           = @board.squares[6]
  #   @sq8           = @board.squares[10]
  #   @sq9           = @board.squares[11]
  #   @sq10          = @board.squares[12]
  #   @sq11          = @board.squares[13]
  #   @sq12          = @board.squares[20]
  #   @sq13          = @board.squares[21]
  #   @sq14          = @board.squares[22]
  #   @sq15          = @board.squares[23]
  #   @sq16          = @board.squares[24]
  #   @ship.squares  = [@sq1, @sq2]
  #   @ship2.squares = [@sq2, @sq3, @sq4]
  #   @ship3.squares = [@sq5, @sq6, @sq7]
  #   @ship4.squares = [@sq8, @sq9, @sq10, @sq11]
  #   @ship5.squares = [@sq12, @sq13, @sq14, @sq15, @sq16]
  #   [@ship, @ship2, @ship3, @ship4, @ship5].each(&:save)
  #   @player1.ships_for(@game).each do |ship|
  #     ship.squares.each { |square| square.state = "guessed" }
  #     ship.save
  #   end
  #   @game.reload
  #   expect(@game.phase).to eq("complete")
  # end
end
