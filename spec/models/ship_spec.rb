require 'spec_helper'

describe Ship do
  let(:ship) { FactoryGirl.create(:ship) }

  it "is valid" do
    expect(ship).to be_valid
  end

  it "is valid with a kind of 'battleship'" do
    ship.kind = "battleship"
    expect(ship).to be_valid
  end

  it "is valid with a kind of 'submarine'" do
    ship.kind = "submarine"
    expect(ship).to be_valid
  end

  it "is valid with a kind of 'destroyer'" do
    ship.kind = "destroyer"
    expect(ship).to be_valid
  end

  it "is valid with a kind of 'aircraft carrier'" do
    ship.kind = "aircraft carrier"
    expect(ship).to be_valid
  end

  it "is valid with a kind of 'patrol boat'" do
    ship.kind = "patrol boat"
    expect(ship).to be_valid
  end

  it "is not valid with some other ship kind" do
    ship.kind = "cruise ship"
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

  describe "setting a ship" do
    it "updates the square when it is set" do
      ship.state = :unset
      expect(ship.square.state).to eq("empty")
      ship.set
      expect(ship.square.state).to eq("taken")
    end
  end

  describe "getting hit" do
    it "updates the square when it is hit" do
      ship.set
      ship.hit
      expect(ship.square.state).to eq("hit")
    end
  end

  describe "length" do
    it "is length five when kind is aircraft carrier" do
      ship.kind = "aircraft carrier"
      expect(ship.length).to equal(5)
    end

    it "is length four when kind is battleship" do
      ship.kind = "battleship"
      expect(ship.length).to equal(4)
    end

    it "is length three when kind is submarine" do
      ship.kind = "submarine"
      expect(ship.length).to equal(3)
    end

    it "is length three when kind is destroyer" do
      ship.kind = "destroyer"
      expect(ship.length).to equal(3)
    end

    it "is length two when kind is patrol boat" do
      ship.kind = "patrol boat"
      expect(ship.length).to equal(2)
    end
  end
end
