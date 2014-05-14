require 'spec_helper'

describe "Boards API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @p1     = @board.player
      @square = @board.squares.first
      @ship   = @board.ships.first

      get api_v1_board_url(@board)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns a link to the board" do
      expect(json["links"][0]["href"]).to eq(api_v1_board_url(@board))
      expect(json["links"][0]["rel"]).to eq("self")
    end

    it "returns the board's id" do
      expect(json["id"]).to eq(@board.id)
    end

    it "returns the board's state" do
      expect(json["state"]).to eq(@board.state)
    end

    it "returns the board's ships" do
      expect(json["ships"][0]["links"][0]["href"]).to eq(api_v1_board_ship_url(@board, @ship))
    end

    it "returns the board's squares" do
      expect(json["squares"][0]["links"][0]["href"]).to eq(api_v1_board_square_url(@board, @square))
    end

    it "returns the board's game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_url(@game))
    end

    it "returns the board's player" do
      expect(json["player"]["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @p1))
    end
  end

  describe "Update Action :" do
    def update_board_json
      @board.state = "lockable"
      @board.state = "locked"
      { :format => :json, :board => @board.to_json(:include => :squares) }
    end

    describe "When board is lockable" do
      before(:each) do
        @board = setup_board

        put api_v1_board_url(@board), update_board_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "is locked" do
        expect(json["state"]).to eq("locked")
      end
    end

    describe "When board is not previously, but requested to be locked with all ships set" do
      def update_board_json
        @board.state = "lockable"
        @board.state = "locked"
        json = { :format => :json, :board => @board.to_json(:include => :squares) }
        @board.state = "unlocked"
        json
      end

      before(:each) do
        @board = setup_board

        put api_v1_board_url(@board), update_board_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "is locked" do
        expect(json["state"]).to eq("locked")
      end
    end
  end
end
