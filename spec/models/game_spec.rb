require 'spec_helper'

describe Game do
  let(:game) { FactoryGirl.create(:game) }

  it "is valid" do
    expect(game).to be_valid
  end

  it "has two boards" do
    expect(game.boards.length).to eq(2)
  end
end
