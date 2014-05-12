require 'spec_helper'

describe "Boards API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @p1     = @board.player
      @square = @board.squares.first

      get api_v1_board_path(@board)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns a link to the board" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_path(@board))
      expect(json["links"][0]["rel"]).to eq("self")
    end

    it "returns the board's id" do
      expect(json["id"]).to eq(@board.id)
    end

    it "returns the board's squares" do
      expect(json["squares"][0]["links"][0]["href"]).to eq(api_v1_board_square_path(@board, @square))
    end

    it "returns the board's game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_path(@game))
    end

    it "returns the board's player" do
      expect(json["player"]["links"][0]["href"]).to eq(api_v1_game_player_path(@game, @p1))
    end
  end
end
