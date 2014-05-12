require 'spec_helper'

describe "Ships API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @player = @board.player
      @ship   = @board.ships.first

      get api_v1_board_ship_path(@board, @ship)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the ship's self link" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_ship_path(@board, @ship))
      expect(json["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's id" do
      expect(json["id"]).to eq(@ship.id)
    end

    it "returns the ship's kind" do
      expect(json["kind"]).to eq(@ship.kind)
    end

    it "returns the ship's state" do
      expect(json["state"]).to eq(@ship.state)
    end

    it "returns the ship's board" do
      expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_path(@board))
      expect(json["board"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's player" do
      expect(json["player"]["links"][0]["href"]).to eq(api_v1_game_player_path(@game, @player))
      expect(json["player"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_path(@game))
      expect(json["game"]["links"][0]["rel"]).to eq("self")
    end
  end
end
