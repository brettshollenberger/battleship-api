require 'spec_helper'

describe Square do
  describe "Attributes : " do
    let(:square) { FactoryGirl.create(:square) }

    it "is valid" do
      expect(square).to be_valid
    end

    it "is not valid without an x coordinate" do
      square.x = nil
      expect(square).to_not be_valid
    end

    it "is not valid without an y coordinate" do
      square.y = nil
      expect(square).to_not be_valid
    end

    it "is valid with the state :empty" do
      square.state = "empty"
      expect(square).to be_valid
    end

    it "is valid with the state :hit" do
      square.state = "hit"
      expect(square).to be_valid
    end

    it "is valid with the state :miss" do
      square.state = "miss"
      expect(square).to be_valid
    end

    it "is valid with the state :taken" do
      square.state = "taken"
      expect(square).to be_valid
    end

    it "is not valid with some other state" do
      square.state = "filled"
      expect(square).to_not be_valid
    end

    it "is guessed if hit or missed" do
      square.state = "hit"
      expect(square.guessed?).to be_true
    end

    it "is not valid without a board" do
      square.board = nil
      expect(square).to_not be_valid
    end

  end

  describe "Being Guessed" do
    before(:each) do
      @game  = FactoryGirl.create(:game, :with_players)
      @board = @game.boards.first
      @ship  = @board.ships[4]
      @sq1   = @board.squares[0]
      @sq2   = @board.squares[1]
    end

    describe "When empty" do
      before(:each) do
        @sq1.state = "guessed"
      end

      it "it is set to miss if empty" do
        expect(@sq1.miss?).to eq(true)
      end

      it "is guessed" do
        @sq1.state = "guessed"
        expect(@sq1.guessed?).to eq(true)
      end
    end

    describe "When taken" do
      it "it is set to hit if taken" do
        @ship.update(:squares => [@sq1, @sq2])
        @sq1.state = "guessed"
        expect(@sq1.hit?).to eq(true)
      end

      it "its ship is hit" do
        @ship.update(:squares => [@sq1, @sq2])
        @sq1.state = "guessed"
        @ship.save
        expect(@ship.hit?).to eq(true)
      end
    end
  end
end
