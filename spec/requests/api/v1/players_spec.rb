require 'spec_helper'

describe "Players API :" do
  describe "Update Action :" do
    before(:each) do
      @game = FactoryGirl.create(:game)
      @p1   = @game.players.first
      @p2   = @game.players.last
    end

    describe "At the beginning of a new game :" do
      def player_json
        { :format => :json, :player => { :name => "Brett" } }
      end

      describe "When it is the player's turn :" do
        before(:each) do
          put api_v1_game_player_path(@game, @p1), player_json
        end

        it "is a successful request" do
          expect(response).to be_success
        end

        it "returns a 200" do
          expect(response.status).to eq(200)
        end

        it "returns the api version" do
          expect(json["collection"]["version"]).to eq(1)
        end

        it "returns the collection url" do
          expect(json["collection"]["href"]).to eq(api_v1_game_players_path(@game))
        end

        it "returns the player representation" do
          expect(json["collection"]["items"][0]["data"][0]["name"]).to eq("id")
        end

        it "switches turns to the other player" do
          expect(players_links).to include(edit_link_for(@p2))
        end
      end

      describe "When it is not the player's turn :" do
        before(:each) do
          put api_v1_game_player_path(@game, @p2), player_json
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

      describe "After both players have set their names :" do
        before(:each) do
          put api_v1_game_player_path(@game, @p1), player_json
          put api_v1_game_player_path(@game, @p2), player_json
        end

        it "is a successful request" do
          expect(response).to be_success
        end

        it "returns a 200" do
          expect(response.status).to eq(200)
        end

        it "switches turns to the other player" do
          expect(json).to eq("")
        end
      end
    end
  end
end
