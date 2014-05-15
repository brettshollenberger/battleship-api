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
      { :format => :json, :board => @board.to_json(:include => [:ships, :squares]) }
    end

    describe "When just requesting board to be locked" do
      before(:each) do
        @board        = setup_board
        @board.state = "lockable"
        @board.state = "locked"

        put api_v1_board_url(@board), { :format => :json, :board => @board.to_json }
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

      it "returns actions for Player 2 to set ships" do
        expect(json["actions"][0]["prompt"]).to eq("Set ship for Player 2")
      end
    end

    describe "When sending ships to set with" do
      before(:each) do
        @board  = setup_board

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

      it "returns actions for Player 2 to set ships" do
        expect(json["actions"][0]["prompt"]).to eq("Set ship for Player 2")
      end
    end

    describe "When requesting board to be locked, but not all ships are set" do
      before(:each) do
        @board       = setup_board
        @board.state = "lockable"
        @board.state = "locked"
        @ship        = @board.ships.first
        @ship.unset
        @board.squares.reload

        put api_v1_board_url(@board), update_board_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "is unlocked" do
        expect(json["state"]).to eq("unlocked")
      end

      it "has set as many ships as possible, and returned links to the remaining ships to be set" do
        expect(json["actions"][0]["href"]).to eq(api_v1_board_ship_url(@board, @ship))
        expect(json["actions"].length).to eq(1)
      end
    end

    describe "When both boards are setup" do
      def update_board_json
        @board2.state = "lockable"
        @board2.state = "locked"
        { :format => :json, :board => @board2.to_json(:include => [:squares, :ships]) }
      end

      describe "When board is lockable" do
        before(:each) do
          @game   = setup_game
          @board2 = @game.boards.last

          put api_v1_board_url(@board2), update_board_json
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

        it "returns start game action" do
          expect(json["actions"][0]["prompt"]).to eq("Player 1: Fire shot")
        end
      end
    end
  end
end
