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

  describe "length" do
    it "is length five when type is aircraft carrier" do
      ship.type = "aircraft carrier"
      expect(ship.length).to equal(5)
    end

    it "is length four when type is battleship" do
      ship.type = "battleship"
      expect(ship.length).to equal(4)
    end

    it "is length three when type is submarine" do
      ship.type = "submarine"
      expect(ship.length).to equal(3)
    end

    it "is length three when type is destroyer" do
      ship.type = "destroyer"
      expect(ship.length).to equal(3)
    end

    it "is length two when type is patrol boat" do
      ship.type = "patrol boat"
      expect(ship.length).to equal(2)
    end
  end
end
