require 'spec_helper'

describe Board do
  before(:each) do
    @game    = FactoryGirl.create(:game, :with_players)
    @player  = @game.players.first
    @player2 = @game.players.last
    @board   = @player.board_for(@game)
    @ship    = @board.ships[4]
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

      it "switches turns after locking" do
        @board.state = "locked"
        @board.save
        @game.reload
        expect(@game.turn).to eq(@player2.id)
      end
    end
  end
end

