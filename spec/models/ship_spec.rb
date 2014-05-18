require 'spec_helper'

describe Ship do
  before(:each) do
    @game   = FactoryGirl.create(:game, :with_players)
    @p1     = @game.players.first
    @p2     = @game.players.last
    @board  = @game.boards.first
    @board2 = @game.boards.last
    @ship   = @board.ships[4]
    @ship2  = @board.ships[3]
    @ship3  = @board.ships[2]
    @ship4  = @board.ships[1]
    @ship5  = @board.ships[0]
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
      @sq5 = @board.squares[4]

      @sq1board1 = @board2.squares[0]
    end

    it "is valid if all assigned squares are contiguous" do
      @ship.update(:squares => [@sq1, @sq2])
      expect(@ship).to be_valid
    end

    it "is not valid if all assigned squares are not contiguous" do
      @ship.update(:squares => [@sq1, @sq3])
      @ship.valid?
      expect(@ship.errors[:squares]).to include("must be contiguous")
    end

    it "is valid if all assigned squares are on the same board" do
      @ship.update(:squares => [@sq1, @sq2])
      expect(@ship).to be_valid
    end

    it "is not valid if assigned squares are from different boards" do
      @ship.update(:squares => [@sq1board1, @sq2])
      @ship.valid?
      expect(@ship.errors[:squares]).to include("must be on the same board")
    end

    it "is valid if set to the correct number of squares" do
      @ship.update(:squares => [@sq1, @sq2])
      expect(@ship).to be_valid
    end

    it "is not valid if set to the incorrect number of squares" do
      @ship.update(:squares => [@sq1, @sq2, @sq3])
      @ship.valid?
      expect(@ship.errors[:squares]).to include("must be set to two squares")
    end

    it "sets state to 'set' when set to the correct number of squares" do
      @ship.update(squares: [@sq1, @sq2])
      expect(@ship.set?).to eq(true)
    end

    it "sets ships to 'taken'" do
      @ship.update(squares: [@sq1, @sq2])
      expect(@ship.squares.all?(&:taken?)).to eq(true)
    end

    it "unsets previously set squares" do
      @ship.update(squares: [@sq1, @sq2])
      @ship.update(squares: [@sq2, @sq3])
      expect(@sq1.taken?).to eq(false)
    end
  end

  describe "Getting Hit/Sunk :" do
    before(:each) do
      @sq1 = @board.squares[0]
      @sq2 = @board.squares[1]
      @ship.update(squares: [@sq1, @sq2])
    end

    it "is hit when any of its squares is hit" do
      @sq1.state = "guessed"
      @ship.save
      expect(@ship.hit?).to eq(true)
    end

    it "is sunk when all of its squares are hit" do
      @sq1.state = "guessed"
      @sq2.state = "guessed"
      @ship.save
      expect(@ship.sunk?).to eq(true)
    end
  end

#   describe "Unsetting Ships :" do
#     before(:each) do
#       @sq1 = @board.squares[0]
#       @sq2 = @board.squares[1]
#       @ship.set([@sq1, @sq2])
#       @ship.unset
#     end

#     it "unsets the ship" do
#       expect(@ship.set?).to be_false
#     end

#     it "unsets each square" do
#       [@sq1, @sq2].each(&:reload)
#       expect([@sq1, @sq2].any?(&:taken?)).to be_false
#     end
#   end

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
