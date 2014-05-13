require 'spec_helper'

describe Ship do
  before(:each) do
    @game  = FactoryGirl.create(:game)
    @board = @game.boards.first
    @ship  = @board.ships.last
  end

  it "is valid" do
    expect(@ship).to be_valid
  end

  it "is valid with a kind of 'battleship'" do
    @ship.kind = "battleship"
    expect(@ship).to be_valid
  end

  it "is valid with a kind of 'submarine'" do
    @ship.kind = "submarine"
    expect(@ship).to be_valid
  end

  it "is valid with a kind of 'destroyer'" do
    @ship.kind = "destroyer"
    expect(@ship).to be_valid
  end

  it "is valid with a kind of 'aircraft carrier'" do
    @ship.kind = "aircraft carrier"
    expect(@ship).to be_valid
  end

  it "is valid with a kind of 'patrol boat'" do
    @ship.kind = "patrol boat"
    expect(@ship).to be_valid
  end

  it "is not valid with some other ship kind" do
    @ship.kind = "cruise ship"
    expect(@ship).to_not be_valid
  end

  it "is not valid without a board" do
    @ship.board = nil
    expect(@ship).to_not be_valid
  end

  it "is valid with a state of 'unset'" do
    @ship.state = "unset"
    expect(@ship).to be_valid
  end

  it "is valid with a state of 'set'" do
    @ship.state = "set"
    expect(@ship).to be_valid
  end

  it "is valid with a state of 'hit'" do
    @ship.state = "hit"
    expect(@ship).to be_valid
  end

  it "is valid with a state of 'sunk'" do
    @ship.state = "sunk"
    expect(@ship).to be_valid
  end

  it "is not valid with some other state" do
    @ship.state = "dead"
    expect(@ship).to_not be_valid
  end

  describe "Setting Ships :" do
    before(:each) do
      @sq1 = @board.squares[0]
      @sq2 = @board.squares[1]
      @sq3 = @board.squares[2]
      @sq4 = @board.squares[3]
    end

    describe "Correctly Setting :" do
      before(:each) do
        @ship.set([@sq1, @sq2])
      end

      it "its state is 'set'" do
        expect(@ship.set?).to eq(true)
      end

      it "assigns a relationship to each square" do
        expect(@sq1.ship).to eq(@ship)
        expect(@sq2.ship).to eq(@ship)
      end

      it "sets each square's state to 'taken'" do
        expect(@sq1.taken?).to eq(true)
        expect(@sq2.taken?).to eq(true)
      end

      describe "When Previously Set to Squares :" do
        before(:each) do
          @ship.set([@sq3, @sq4])
        end

        it "assigns a relationship to each new square" do
          expect(@sq3.ship).to eq(@ship)
          expect(@sq4.ship).to eq(@ship)
        end

        it "unsets previously set squares" do
          [@sq1, @sq2].each(&:reload)
          expect(@sq1.taken?).to eq(false)
          expect(@sq2.taken?).to eq(false)
        end
      end

      describe "When Previously Set to Some of the Same Squares:" do
        before(:each) do
          @ship.set([@sq2, @sq3])
        end

        it "assigns a relationship to each new square" do
          expect(@sq2.ship).to eq(@ship)
          expect(@sq3.ship).to eq(@ship)
        end

        it "unsets previously set squares" do
          [@sq1].each(&:reload)
          expect(@sq1.taken?).to eq(false)
        end
      end
    end

    describe "Incorrectly Setting :" do
      it "does not set a ship to the wrong number of squares" do
        @ship.set([@sq1, @sq2, @sq3])
        expect(@ship.set?).to eq(false)
      end

      it "does not set a ship to taken squares" do
        @sq1.state = "taken"
        @ship.set([@sq1, @sq2])
        expect(@ship.set?).to eq(false)
      end
    end
  end

  describe "getting hit" do
    # it "updates the square when it is hit" do
    #   ship.set
    #   ship.hit
    #   expect(ship.square.state).to eq("hit")
    # end
  end

  describe "length" do
    it "is length five when kind is aircraft carrier" do
      @ship.kind = "aircraft carrier"
      expect(@ship.length).to equal(5)
    end

    it "is length four when kind is battleship" do
      @ship.kind = "battleship"
      expect(@ship.length).to equal(4)
    end

    it "is length three when kind is submarine" do
      @ship.kind = "submarine"
      expect(@ship.length).to equal(3)
    end

    it "is length three when kind is destroyer" do
      @ship.kind = "destroyer"
      expect(@ship.length).to equal(3)
    end

    it "is length two when kind is patrol boat" do
      @ship.kind = "patrol boat"
      expect(@ship.length).to equal(2)
    end
  end
end
