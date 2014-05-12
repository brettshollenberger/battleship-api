require 'spec_helper'

describe "Squares API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @square = @board.squares.first

      get api_v1_board_square_path(@board, @square)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the square's href" do
      expect(json["href"]).to eq(api_v1_board_square_path(@board, @square))
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

    it "returns the square's board_id" do
      expect(json["board_id"]).to eq(@square.board_id)
    end

    it "returns the square's game_id" do
      expect(json["game_id"]).to eq(@square.game_id)
    end

    describe "links" do
      it "returns a link to the square's board" do
        expect(json["board"]["links"][0]["rel"]).to eq("get")
        expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_path(@board))
      end

      it "returns a link to the square's game" do
        expect(json["game"]["links"][0]["rel"]).to eq("get")
        expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_path(@game))
      end
    end
  end
end
