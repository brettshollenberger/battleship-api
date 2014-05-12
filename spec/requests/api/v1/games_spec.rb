require 'spec_helper'

describe "Boards API :" do
  describe "Show Action :" do
    before(:each) do
      @game   = FactoryGirl.create(:game)
      @board  = @game.boards.first
      @p1     = @board.player
      @square = @board.squares.first
      @ship   = @board.ships.first

      get api_v1_game_path(@game)
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns the game's links" do
      expect(json["links"][0]["href"]).to eq(api_v1_game_url(@game))
    end

    it "returns the available actions" do
      expect(json["actions"][0]["href"]).to eq(api_v1_game_player_url(@game, @p1))
      expect(json["actions"][0]["rel"]).to eq("edit")
      expect(json["actions"][0]["prompt"]).to eq("Choose a name for Player 1")
    end

    it "returns the game's id" do
      expect(json["id"]).to eq(@game.id)
    end

    it "returns the game's phase" do
      expect(json["phase"]).to eq(@game.phase)
    end

    it "returns the game's turn" do
      expect(json["turn"]).to eq(@game.turn)
    end

    it "returns the game's players" do
      expect(json["players"][0]["links"][0]["href"]).to eq(api_v1_game_player_url(@game, @p1))
    end
  end
end

#   describe "Create Action :" do
#     before(:each) do
#       post api_v1_games_path
#       @game = Game.find(json["id"])
#       @p1   = @game.players.first
#       @p2   = @game.players.last
#     end

#     it "is a successful request" do
#       expect(response).to be_success
#     end

#     it "returns its id" do
#       expect(json["id"]).to eq(@game.id)
#     end

#     it "returns its phase" do
#       expect(json["phase"]).to eq(@game.phase)
#     end

#     it "returns its turn" do
#       expect(json["turn"]).to eq(@game.turn)
#     end

#     it "returns its players" do
#       expect(json["players"][0]["id"]).to eq(@p1.id)
#       expect(json["players"][1]["id"]).to eq(@p2.id)
#     end

#     it "returns get and put links for player 1" do
#       expect(json["players"][0]["links"][0]["rel"]).to eq("get")
#       expect(json["players"][0]["links"][1]["rel"]).to eq("put")
#     end

#     it "returns only get link for player 2" do
#       expect(json["players"][1]["links"][0]["rel"]).to eq("get")
#       expect(json["players"][1]["links"].length).to eq(1)
#     end
#   end
# end
