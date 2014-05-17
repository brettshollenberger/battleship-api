require 'spec_helper'

describe Board do
  before(:each) do
    @game   = FactoryGirl.create(:game)
    @player = @game.players.first
    @board  = @player.board_for(@game)
    @ship   = @board.ships[4]
  end

  describe "Attributes" do
    it "is valid" do
      expect(@board).to be_valid
    end

    it "is valid with a state of 'unlocked'" do
      @board.state = "unlocked"
      expect(@board).to be_valid
    end

    it "is valid with a state of 'lockable'" do
      @board.state = "lockable"
      expect(@board).to be_valid
    end

    it "is valid with a state of 'locked'" do
      @board.state = "lockable"
      @board.state = "locked"
      expect(@board).to be_valid
    end

    it "sets one hundred squares" do
      expect(@board.squares.count).to eq(100)
    end

    it "sets five ships" do
      expect(@board.ships.first.kind).to eq("aircraft carrier")
    end
  end

  describe "Setting Ships :" do
    before(:each) do
      @ship2 = @board.ships[3]
      @ship3 = @board.ships[2]
      @ship4 = @board.ships[1]
      @ship5 = @board.ships[0]
      @sq1   = @board.squares[0]
      @sq2   = @board.squares[1]
      @sq3   = @board.squares[2]
      @sq4   = @board.squares[3]
      @sq5   = @board.squares[4]
      @sq6   = @board.squares[5]
      @sq7   = @board.squares[6]
      @sq8   = @board.squares[10]
      @sq9   = @board.squares[11]
      @sq10  = @board.squares[12]
      @sq11  = @board.squares[13]
      @sq12  = @board.squares[20]
      @sq13  = @board.squares[21]
      @sq14  = @board.squares[22]
      @sq15  = @board.squares[23]
      @sq16  = @board.squares[24]
    end

    it "is valid if all ships are valid" do
      @ship.update(:squares => [@sq1, @sq2])
      expect(@board).to be_valid
    end

    it "is not valid if any ship is invalid" do
      @ship.update(:squares => [@sq1])
      expect(@board).to_not be_valid
    end

    describe "Locking" do
      before(:each) do
        @ship.squares  = [@sq1, @sq2]
        @ship2.squares = [@sq2, @sq3, @sq4]
        @ship3.squares = [@sq5, @sq6, @sq7]
        @ship4.squares = [@sq8, @sq9, @sq10, @sq11]
        @ship5.squares = [@sq12, @sq13, @sq14, @sq15, @sq16]
        @board.save
      end

      it "is lockable when all ships are set" do
        expect(@board.state).to eq("lockable")
      end

      it "is unlocked when ships become unset" do
        @ship.squares = []
        @board.save
        expect(@board.state).to eq("unlocked")
      end

      it "is locked when lockable and saved with locked" do
        @board.state = "locked"
        expect(@board.state).to eq("locked")
      end
    end
  end

#   describe "board#settable?(ship: ship, squares: squares)" do
#     before(:each) do
#       @game            = FactoryGirl.create(:game)
#       @board           = @game.boards.first
#       @board2          = @game.boards.last
#       @ship            = @board.ships[2]
#       @ship2           = @board.ships.first
#       @sq1             = @board.squares.where(x: "1", y: "A").first
#       @sq2             = @board.squares.where(x: "2", y: "A").first
#       @sq3             = @board.squares.where(x: "3", y: "A").first
#       @sq4             = @board.squares.where(x: "1", y: "B").first
#       @sq5             = @board.squares.where(x: "1", y: "C").first
#       @sq1_from_board2 = @board2.squares.where(x: "1", y: "A").first
#     end

#     it "uses numerically_sequential? to determine whether squares have increasing X value" do
#       expect(@board.numerically_sequential?([@sq1, @sq2, @sq3])).to eq(true)
#       expect(@board.numerically_sequential?([@sq1, @sq2, @sq4])).to eq(false)
#     end

#     it "uses alphabetically_sequential? to determine whether squares have increasing Y value" do
#       expect(@board.alphabetically_sequential?([@sq1, @sq2, @sq3])).to eq(false)
#       expect(@board.alphabetically_sequential?([@sq3, @sq4, @sq5])).to eq(true)
#     end

#     it "uses same? to determine whether a set of squares has the same value of a given attribute" do
#       expect(@board.same?([@sq1, @sq2, @sq3], :x)).to eq(false)
#       expect(@board.same?([@sq1, @sq4, @sq5], :x)).to eq(true)
#       expect(@board.same?([@sq1, @sq2, @sq3], :y)).to eq(true)
#       expect(@board.same?([@sq1, @sq4, @sq5], :y)).to eq(false)
#       expect(@board.same?([@sq1, @sq2, @sq3], :board)).to eq(true)
#       expect(@board.same?([@sq1_from_board2, @sq4, @sq5], :board)).to eq(false)
#     end

#     it "is contiguous when a set of squares appears together in a row" do
#       expect(@board.contiguous?([@sq1, @sq2, @sq3])).to eq(true)
#       expect(@board.contiguous?([@sq4, @sq2, @sq3])).to eq(false)
#     end

#     it "is contiguous when a set of squares appears together in a column" do
#       expect(@board.contiguous?([@sq1, @sq4, @sq5])).to eq(true)
#       expect(@board.contiguous?([@sq4, @sq2, @sq3])).to eq(false)
#     end

#     it "is contiguous when contiguous squares are not given as arguments in the correct order" do
#       expect(@board.contiguous?([@sq3, @sq1, @sq2])).to eq(true)
#       expect(@board.contiguous?([@sq4, @sq5, @sq1])).to eq(true)
#     end

#     it "allows squares to be set if they are all empty and contiguous" do
#       expect(@board.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship)).to eq(true)
#       @sq1.state = "set"
#       expect(@board.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship)).to eq(false)
#     end

#     it "allows only squares on the same board to be set together" do
#       expect(@board.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship)).to eq(true)
#       expect(@board.settable?(squares: [@sq1_from_board2, @sq2, @sq3], ship: @ship)).to eq(false)
#     end

#     it "allows only the board that owns the squares to declare the squares settable" do
#       expect(@board2.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship)).to eq(false)
#     end

#     it "only allows squares to be set to a ship of the proper length" do
#       expect(@board.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship)).to eq(true)
#       expect(@board.settable?(squares: [@sq1, @sq2, @sq3], ship: @ship2)).to eq(false)
#     end
#   end
end
