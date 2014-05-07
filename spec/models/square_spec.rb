require 'spec_helper'

describe Square do
  let(:square) { FactoryGirl.create(:square) }

  it "is valid" do
    expect(square).to be_valid
  end

  it "is not valid without an x coordinate" do
    square.x = nil
    expect(square).to_not be_valid
  end

  it "is not valid without an y coordinate" do
    square.y = nil
    expect(square).to_not be_valid
  end

  it "is valid with the state :empty" do
    square.state = "empty"
    expect(square).to be_valid
  end

  it "is valid with the state :hit" do
    square.state = "hit"
    expect(square).to be_valid
  end

  it "is valid with the state :taken" do
    square.state = "taken"
    expect(square).to be_valid
  end

  it "is not valid with some other state" do
    square.state = "filled"
    expect(square).to_not be_valid
  end

  it "is not valid without a board" do
    square.board = nil
    expect(square).to_not be_valid
  end
end
