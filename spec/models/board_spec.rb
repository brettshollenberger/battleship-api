require 'spec_helper'

describe Board do
  before(:each) do
    @game = FactoryGirl.create(:game)
    @player = @game.players.first
    @board  = @player.board_for(@game)
  end

  it "is valid" do
    expect(@board).to be_valid
  end

  it "sets one hundred squares" do
    expect(@board.get("J", 10).class).to eq(Square)
  end

  it "sets five ships" do
    expect(@board.ships.first.kind).to eq("aircraft carrier")
  end
end
