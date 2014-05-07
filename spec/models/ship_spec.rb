require 'spec_helper'

describe Ship do
  let(:ship) { FactoryGirl.create(:ship) }

  it "is valid" do
    expect(ship).to be_valid
  end

  it "is valid with a type of 'battleship'" do
    ship.type = "battleship"
    expect(ship).to be_valid
  end

  it "is valid with a type of 'submarine'" do
    ship.type = "submarine"
    expect(ship).to be_valid
  end

  it "is valid with a type of 'destroyer'" do
    ship.type = "destroyer"
    expect(ship).to be_valid
  end

  it "is valid with a type of 'aircraft carrier'" do
    ship.type = "aircraft carrier"
    expect(ship).to be_valid
  end

  it "is valid with a type of 'patrol boat'" do
    ship.type = "patrol boat"
    expect(ship).to be_valid
  end

  it "is not valid with some other ship type" do
    ship.type = "cruise ship"
    expect(ship).to_not be_valid
  end

  it "is not valid without a board" do
    ship.board = nil
    expect(ship).to_not be_valid
  end

  it "is valid with a state of 'unset'" do
    ship.state = "unset"
    expect(ship).to be_valid
  end

  it "is valid with a state of 'set'" do
    ship.state = "set"
    expect(ship).to be_valid
  end

  it "is valid with a state of 'hit'" do
    ship.state = "hit"
    expect(ship).to be_valid
  end

  it "is valid with a state of 'sunk'" do
    ship.state = "sunk"
    expect(ship).to be_valid
  end

  it "is not valid with some other state" do
    ship.state = "dead"
    expect(ship).to_not be_valid
  end
end
