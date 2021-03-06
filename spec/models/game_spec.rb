require 'spec_helper'

describe Game do

  before(:each) do
    @game    = FactoryGirl.create(:game)
    @player1 = @game.players.first
    @player2 = @game.players.last
  end

  it "is valid" do
    expect(@game).to be_valid
  end

  it "is valid with a state of setup_players" do
    @game.phase = "setup_players"
    expect(@game).to be_valid
  end

  it "is valid with a state of setup_ships" do
    @game.phase = "setup_ships"
    expect(@game).to be_valid
  end

  it "is valid with a state of play" do
    @game.phase = "play"
    expect(@game).to be_valid
  end

  it "is valid with a state of complete" do
    @game.phase = "complete"
    expect(@game).to be_valid
  end

  it "is not valid with some other state" do
    @game.phase = "finished"
    expect(@game).to_not be_valid
  end

  it "has two players" do
    expect(@game.players.length).to eq(2)
  end

  it "has two boards" do
    expect(@game.boards.length).to eq(2)
  end

  it "starts with the first player's turn" do
    expect(@game.turn).to eq(@game.players.first.id)
  end

  it "toggles turns" do
    @game.toggle_turn
    expect(@game.turn).to eq(@game.players.second.id)
    @game.toggle_turn
    expect(@game.turn).to eq(@game.players.first.id)
  end

  describe "controls" do
    it "always contains a control to create a new game" do
      expect(@game.controls).to include({rel: "post", item: "game"})
    end

    describe "setup players phase" do
      it "has an initial control to setup the first player" do
        expect(@game.controls).to include({rel: "edit", association: @game.players.first})
      end

      it "has a control to setup the second player after the first player is setup" do
        @game.players.first.name = "Brett"
        expect(@game.controls).to include({rel: "edit", association: @game.players.last})
      end
    end

    describe "setup ships phase" do
      before(:each) do
        @player1.name = "Brett"
        @player2.name = "Tag"
      end

      it "has controls to set the first player's ships after both players are setup" do
        expect(@game.controls).to include({rel: "edit",
                              association: @player1.board_for(@game).ships.first})

        expect(@game.controls).to_not include({rel: "edit",
                              association: @player2.board_for(@game).ships.first})
      end

      it "has controls to set P2's ships after the P1's ships are set" do
        @player1.board_for(@game).ships.each(&:set)

        expect(@game.controls).to include({rel: "edit",
                              association: @player2.board_for(@game).ships.first})

        expect(@game.controls).to_not include({rel: "edit",
                              association: @player1.board_for(@game).ships.first})
      end
    end

    describe "play phase" do
      before(:each) do
        @player1.name = "Brett"
        @player2.name = "Tag"
        @player1.board_for(@game).ships.each(&:set)
        @player2.board_for(@game).ships.each(&:set)
      end

      it "has a control for P1 to fire a shot on P2's board after the ships are set" do
        expect(@game.controls).to include({rel: "edit",
                                   association: @player2.board_for(@game).squares.first})
      end

      it "has a control for P2 to fire a shot after P1's turn" do
        @square = @player2.board_for(@game).squares.first
        @player1.fire(@square) && @game.toggle_turn
        expect(@game.controls).to include({rel: "edit",
                                   association: @player1.board_for(@game).squares.first})
      end
    end
  end
end
