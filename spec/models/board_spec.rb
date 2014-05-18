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
      @sq1   = @board.squares[0]
      @sq2   = @board.squares[1]
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
      describe "Unlocked" do
        it "is unlocked when not all ships are set" do
          expect(@board.state).to eq("unlocked")
        end
      end

      describe "Lockable/Locked" do
        before(:each) do
          @board.set.random
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
end

