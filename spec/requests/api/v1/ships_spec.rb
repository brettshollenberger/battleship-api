require 'spec_helper'

describe "Ships API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @player = @board.player
      @ship   = @board.ships.first

      get api_v1_board_ship_url(@board, @ship)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the ship's self link" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_ship_url(@board, @ship))
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

    it "returns the ship's length" do
      expect(json["length"]).to eq(@ship.length)
    end

    it "returns the ship's board" do
      expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_url(@board))
      expect(json["board"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's player" do
      expect(json["player"]["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @player))
      expect(json["player"]["links"][0]["rel"]).to eq("self")
    end

    it "returns the ship's game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_url(@game))
      expect(json["game"]["links"][0]["rel"]).to eq("self")
    end
  end

  describe "Update Action :" do
    def update_ship_json
      { :format => :json, :ship => { :squares => [@sq1.to_json, @sq2.to_json] } }
    end

    describe "In ship setting mode" do
      describe "When it is the Player's Turn" do
        before(:each) do
          @game  = FactoryGirl.create(:game)
          @board = @game.boards.first
          @sq1   = @board.squares[0]
          @sq2   = @board.squares[1]
          @ship  = @board.ships.last

          put api_v1_board_ship_url(@board, @ship), update_ship_json
        end

        it "is a successful request" do
          expect(response).to be_success
        end

        it "returns a 200" do
          expect(response.status).to eq(200)
        end

        it "returns the ship's squares" do
          expect(json["squares"][0]["id"]).to eq(@sq1.id)
          expect(json["squares"][1]["id"]).to eq(@sq2.id)
        end
      end
    end
  end
end
