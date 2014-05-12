require 'spec_helper'

describe "Players API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @player = @board.player

      get api_v1_game_player_url(@game, @player)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the player's name" do
      expect(json["name"]).to eq(@player.name)
    end

    it "returns the player's id" do
      expect(json["id"]).to eq(@player.id)
    end

    it "returns the player's board for the game" do
      expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_url(@board))
    end

    it "returns a link to the game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_url(@game))
    end

    describe "During Setup Player Phase" do
      describe "When it is the player's turn" do
        it "returns a link to get the player" do
          expect(json["links"][0]["rel"]).to eq("self")
          expect(json["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @player))
        end

        it "returns a link to edit the player's name" do
          expect(json["links"][1]["rel"]).to eq("edit")
          expect(json["links"][1]["href"]).to eq(api_v1_game_player_url(@game, @player))
          expect(json["links"][1]["prompt"]).to eq("Choose a name for Player 1")
        end
      end

      describe "When it is not the player's turn" do
        before(:each) do
          @game  = FactoryGirl.create(:game)
          @b1    = @game.boards.first
          @p1    = @b1.player
          @board = @game.boards.last
          @p2    = @board.player

          get api_v1_game_player_url(@game, @player)
        end

        it "returns a link to get the player" do
          expect(json["links"][0]["rel"]).to eq("self")
          expect(json["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @player))
        end

        it "does not return a link to to edit the player's name" do
          expect(json["links"][1]).to eq(nil)
        end
      end
    end
  end

  describe "Update Action :" do
    def update_player_json
      { :format => :json, :player => { :name => "Brett" } }
    end

    describe "When it is the Player's Turn" do
      before(:each) do
        @game   = FactoryGirl.create(:game)
        @board  = @game.boards.first
        @player = @board.player

        put api_v1_game_player_url(@game, @player), update_player_json
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "returns a 200" do
        expect(response.status).to eq(200)
      end

      it "responds with the updated player" do
        expect(json["name"]).to eq("Brett")
      end

      it "responds with the available actions" do
        expect(json["actions"][0]["prompt"]).to eq("Choose a name for Player 2")
      end
    end

    describe "When it is not the player's turn" do
      before(:each) do
        @game   = FactoryGirl.create(:game)
        @board  = @game.boards.last
        @player = @board.player

        put api_v1_game_player_url(@game, @player), update_player_json
      end

      it "is not a successful request" do
        expect(response).to_not be_success
      end

      it "returns a forbidden status code" do
        expect(response.status).to eq(403)
      end

      it "returns an error message" do
        expect(json["message"]).to eq("It is not that player's turn.")
      end
    end
  end
end
