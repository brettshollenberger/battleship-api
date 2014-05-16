require 'spec_helper'

describe Ship do
  before(:each) do
    @game   = FactoryGirl.create(:game)
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
      @ship.squares << @sq1
      @ship.squares << @sq2
      expect(@ship).to be_valid
    end

    it "is not valid if all assigned squares are not contiguous" do
      @ship.squares << @sq1
      @ship.squares << @sq3
      @ship.valid?
      expect(@ship.errors[:squares]).to include("must be contiguous")
    end

    it "is valid if all assigned squares are on the same board" do
      @ship.squares << @sq1
      @ship.squares << @sq2
      expect(@ship).to be_valid
    end

    it "is not valid if assigned squares are from different boards" do
      @ship.squares << @sq1board1
      @ship.squares << @sq2
      @ship.valid?
      expect(@ship.errors[:squares]).to include("must be on the same board")
    end
  end

#   describe "Setting Ships :" do
#     before(:each) do
#       @sq1 = @board.squares[0]
#       @sq2 = @board.squares[1]
#       @sq3 = @board.squares[2]
#       @sq4 = @board.squares[3]
#     end

#     describe "Correctly Setting :" do
#       before(:each) do
#         @ship.set([@sq1, @sq2])
#       end

#       it "its state is 'set'" do
#         expect(@ship.set?).to eq(true)
#       end

#       it "assigns a relationship to each square" do
#         expect(@sq1.ship).to eq(@ship)
#         expect(@sq2.ship).to eq(@ship)
#       end

#       it "sets each square's state to 'taken'" do
#         expect(@sq1.taken?).to eq(true)
#         expect(@sq2.taken?).to eq(true)
#       end

#       describe "When Previously Set to Squares :" do
#         before(:each) do
#           @ship.set([@sq3, @sq4])
#         end

#         it "assigns a relationship to each new square" do
#           expect(@sq3.ship).to eq(@ship)
#           expect(@sq4.ship).to eq(@ship)
#         end

#         it "unsets previously set squares" do
#           [@sq1, @sq2].each(&:reload)
#           expect(@sq1.taken?).to eq(false)
#           expect(@sq2.taken?).to eq(false)
#         end
#       end

#       describe "When Previously Set to Some of the Same Squares :" do
#         before(:each) do
#           @ship.set([@sq2, @sq3])
#         end

#         it "assigns a relationship to each new square" do
#           expect(@sq2.ship).to eq(@ship)
#           expect(@sq3.ship).to eq(@ship)
#         end

#         it "unsets previously set squares" do
#           [@sq1].each(&:reload)
#           expect(@sq1.taken?).to eq(false)
#         end
#       end

#       describe "When All Ships for A Player Are Set :" do

#         before(:each) do
#           @sq5  = @board.squares[4]
#           @sq6  = @board.squares[5]
#           @sq7  = @board.squares[6]
#           @sq8  = @board.squares[7]
#           @sq9  = @board.squares[10]
#           @sq10 = @board.squares[11]
#           @sq11 = @board.squares[12]
#           @sq12 = @board.squares[13]
#           @sq13 = @board.squares[14]
#           @sq14 = @board.squares[15]
#           @sq15 = @board.squares[16]
#           @sq16 = @board.squares[17]
#           @sq17 = @board.squares[18]

#           @ship2.set([@sq3, @sq4, @sq5])
#           @ship3.set([@sq6, @sq7, @sq8])
#           @ship4.set([@sq9, @sq10, @sq11, @sq12])
#           @ship5.set([@sq13, @sq14, @sq15, @sq16, @sq17])
#         end

#         it "has all ships for a board set" do
#           expect(@board.ships.set?).to eq(true)
#         end

#         it "sets the board's state to 'lockable'" do
#           @board.reload
#           expect(@board.lockable?).to eq(true)
#         end
#       end
#     end

#     describe "Incorrectly Setting :" do
#       describe "Wrong number of squares :" do
#         before(:each) do
#           @ship.set([@sq1, @sq2, @sq3])
#         end

#         it "does not set a ship to the wrong number of squares" do
#           expect(@ship.set?).to eq(false)
#         end

#         it "adds an error message" do
#           expect(@ship.errors[:squares]).to include("can only be assigned to two squares")
#         end

#         it "removes the error on validation" do
#           @ship.set([@sq1, @sq2])
#           expect(@ship.errors[:squares]).to_not include("can only be assigned to two squares")
#         end
#       end
#     end

#     describe "Setting a ship on taken squares :" do
#       before(:each) do
#         @sq1.state = "taken"
#         @ship.set([@sq1, @sq2])
#       end

#       it "does not set a ship to taken squares" do
#         expect(@ship.set?).to eq(false)
#       end

#       it "adds an error message" do
#         expect(@ship.errors[:squares]).to include("square #{@sq1.id} is already taken")
#       end

#       it "removes the error on validation" do
#         @ship.set([@sq2, @sq3])
#         expect(@ship.errors[:squares]).to_not include("square #{@sq1.id} is already taken")
#       end
#     end

#     describe "Setting a ship out of turn :" do
#       before(:each) do
#         @game.toggle_turn
#         @ship.set([@sq1, @sq2])
#       end

#       it "does not set a ship out of turn" do
#         expect(@ship.set?).to eq(false)
#       end

#       it "adds an error message" do
#         expect(@ship.errors[:squares]).to include("cannot be set out of turn")
#       end

#       it "removes the error on validation" do
#         @game.toggle_turn
#         @ship.set([@sq2, @sq3])
#         expect(@ship.errors[:squares]).to_not include("cannot be set out of turn")
#       end
#     end
#   end

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
