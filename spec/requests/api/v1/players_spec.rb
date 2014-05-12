require 'spec_helper'

describe "Players API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @player = @board.player

      get api_v1_game_player_path(@game, @player)
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
      expect(json["board"]["links"][0]["href"]).to eq(api_v1_board_path(@board))
    end

    it "returns a link to the game" do
      expect(json["game"]["links"][0]["href"]).to eq(api_v1_game_path(@game))
    end

    describe "During Setup Player Phase" do
      describe "When it is the player's turn" do
        it "returns a link to get the player" do
          expect(json["links"][0]["rel"]).to eq("self")
          expect(json["links"][0]["href"]).to eq(api_v1_game_player_path(@game, @player))
        end

        it "returns a link to edit the player's name" do
          expect(json["links"][1]["rel"]).to eq("edit")
          expect(json["links"][1]["href"]).to eq(api_v1_game_player_path(@game, @player))
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

          get api_v1_game_player_path(@game, @player)
        end

        it "returns a link to get the player" do
          expect(json["links"][0]["rel"]).to eq("self")
          expect(json["links"][0]["href"]).to eq(api_v1_game_player_path(@game, @player))
        end

        it "does not return a link to to edit the player's name" do
          expect(json["links"][1]).to eq(nil)
        end
      end
    end
  end
end
