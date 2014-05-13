require 'spec_helper'

describe Board do
  describe "Attributes" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @player = @game.players.first
      @board  = @player.board_for(@game)
    end

    it "is valid" do
      expect(@board).to be_valid
    end

    it "sets one hundred squares" do
      expect(@board.get("J", 10).class).to eq(Square)
    end

    it "sets five ships" do
      expect(@board.ships.first.kind).to eq("aircraft carrier")
    end
  end

  describe "board#squares_settable?(squares)" do
    before(:each) do
      @game            = FactoryGirl.create(:game)
      @board           = @game.boards.first
      @board2          = @game.boards.last
      @sq1             = @board.squares.where(x: "1", y: "A").first
      @sq2             = @board.squares.where(x: "2", y: "A").first
      @sq3             = @board.squares.where(x: "3", y: "A").first
      @sq4             = @board.squares.where(x: "1", y: "B").first
      @sq5             = @board.squares.where(x: "1", y: "C").first
      @sq1_from_board2 = @board2.squares.where(x: "1", y: "A").first
    end

    it "uses numerically_sequential? to determine whether squares have increasing X value" do
      expect(@board.numerically_sequential?([@sq1, @sq2, @sq3])).to eq(true)
      expect(@board.numerically_sequential?([@sq1, @sq2, @sq4])).to eq(false)
    end

    it "uses alphabetically_sequential? to determine whether squares have increasing Y value" do
      expect(@board.alphabetically_sequential?([@sq1, @sq2, @sq3])).to eq(false)
      expect(@board.alphabetically_sequential?([@sq3, @sq4, @sq5])).to eq(true)
    end

    it "uses same? to determine whether a set of squares has the same value of a given attribute" do
      expect(@board.same?([@sq1, @sq2, @sq3], :x)).to eq(false)
      expect(@board.same?([@sq1, @sq4, @sq5], :x)).to eq(true)
      expect(@board.same?([@sq1, @sq2, @sq3], :y)).to eq(true)
      expect(@board.same?([@sq1, @sq4, @sq5], :y)).to eq(false)
      expect(@board.same?([@sq1, @sq2, @sq3], :board)).to eq(true)
      expect(@board.same?([@sq1_from_board2, @sq4, @sq5], :board)).to eq(false)
    end

    it "is contiguous when a set of squares appears together in a row" do
      expect(@board.contiguous?([@sq1, @sq2, @sq3])).to eq(true)
      expect(@board.contiguous?([@sq4, @sq2, @sq3])).to eq(false)
    end

    it "is contiguous when a set of squares appears together in a column" do
      expect(@board.contiguous?([@sq1, @sq4, @sq5])).to eq(true)
      expect(@board.contiguous?([@sq4, @sq2, @sq3])).to eq(false)
    end

    it "is contiguous when contiguous squares are not given as arguments in the correct order" do
      expect(@board.contiguous?([@sq3, @sq1, @sq2])).to eq(true)
      expect(@board.contiguous?([@sq4, @sq5, @sq1])).to eq(true)
    end

    it "allows squares to be set if they are all empty and contiguous" do
      expect(@board.squares_settable?([@sq1, @sq2, @sq3])).to eq(true)
      @sq1.state = "set"
      expect(@board.squares_settable?([@sq1, @sq2, @sq3])).to eq(false)
    end

    it "allows only squares on the same board to be set together" do
      expect(@board.squares_settable?([@sq1, @sq2, @sq3])).to eq(true)
      expect(@board.squares_settable?([@sq1_from_board2, @sq2, @sq3])).to eq(false)
    end

    it "allows only the board that owns the squares to declare the squares settable" do
      expect(@board2.squares_settable?([@sq1, @sq2, @sq3])).to eq(false)
    end
  end
end
