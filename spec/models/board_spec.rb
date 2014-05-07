require 'spec_helper'

describe Board do
  let(:board) { FactoryGirl.create(:board) }

  it "is valid" do
    expect(board).to be_valid
  end

  it "sets one hundred squares" do
    expect(board.get("J", 10).class).to eq(Square)
  end

  it "sets five ships" do
    expect(board.ships.first.kind).to eq("aircraft carrier")
  end
end
