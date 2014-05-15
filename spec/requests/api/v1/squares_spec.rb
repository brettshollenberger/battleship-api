require 'spec_helper'

describe "Squares API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @square = @board.squares.first

      get api_v1_board_square_url(@board, @square)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the square's self link" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_square_url(@board, @square))
      expect(json["links"][0]["rel"]).to eq("self")
    end

    it "returns the square's id" do
      expect(json["id"]).to eq(@square.id)
    end

    it "returns the square's x coordinate" do
      expect(json["x"]).to eq(@square.x)
    end

    it "returns the square's y coordinate" do
      expect(json["y"]).to eq(@square.y)
    end

    it "returns the square's state" do
      expect(json["state"]).to eq(@square.state)
    end

    describe "links" do
      it "returns a link to the square's board" do
        expect(json["board"]["links"][0]["rel"]).to eq("self")
        expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_url(@board))
      end

      it "returns a link to the square's game" do
        expect(json["game"]["links"][0]["rel"]).to eq("self")
        expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_url(@game))
      end
    end
  end

  describe "Update Action :" do
    def update_square_json
      { :format => :json, :square => @square.to_json }
    end

    describe "When it is the Player's Turn" do
      before(:each) do
        @game   = game_in_play_mode
        @board  = @game.boards.last
        @square = @board.squares.first

        put api_v1_board_square_url(@board, @square), update_square_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "responds with the updated square" do
        expect(json["state"]).to eq("hit")
      end

      it "responds with the available actions" do
        expect(json["actions"][0]["prompt"]).to eq("Player 2: Fire shot")
      end
    end

    describe "When the player places the winning shot" do
      before(:each) do
        @game   = finished_game
        @board  = @game.boards.last
        @square = @board.squares.first
        @square.state = "taken"

        put api_v1_board_square_url(@board, @square), update_square_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "responds with the available actions" do
        expect(json["actions"][0]["prompt"]).to eq("Player 1 Victory! Play Again")
      end
    end

    describe "When it is not the Player's Turn" do
      before(:each) do
        @game   = game_in_play_mode
        @board  = @game.boards.first
        @square = @board.squares.first

        put api_v1_board_square_url(@board, @square), update_square_json
      end

      it "is not a successful request" do
        expect(response).to_not be_success
      end

      it "returns a 403" do
        expect(response.status).to eq(403)
      end

      it "responds with the error message" do
        expect(json["message"]).to eq("It is not that player's turn.")
      end
    end
  end
end
