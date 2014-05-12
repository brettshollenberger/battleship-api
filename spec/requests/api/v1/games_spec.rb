require 'spec_helper'

describe "Games API :" do
  describe "Create Action :" do
    before(:each) do
      post api_v1_games_path
      @game = Game.find(json["id"])
      @p1   = @game.players.first
      @p2   = @game.players.last
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "returns its id" do
      expect(json["id"]).to eq(@game.id)
    end

    it "returns its phase" do
      expect(json["phase"]).to eq(@game.phase)
    end

    it "returns its turn" do
      expect(json["turn"]).to eq(@game.turn)
    end

    it "returns its players" do
      expect(json["players"][0]["id"]).to eq(@p1.id)
      expect(json["players"][1]["id"]).to eq(@p2.id)
    end

    it "returns get and put links for player 1" do
      expect(json["players"][0]["links"][0]["rel"]).to eq("get")
      expect(json["players"][0]["links"][1]["rel"]).to eq("put")
    end

    it "returns only get link for player 2" do
      expect(json["players"][1]["links"][0]["rel"]).to eq("get")
      expect(json["players"][1]["links"].length).to eq(1)
    end

    # it "returns a link to the collection of games" do
      # expect(json["collection"]["href"]).to eq(api_v1_games_path)
    # end

    # it "returns the game's phase attribute" do
      # expect(json["collection"]["items"][0]["data"][0]["name"]).to eq("id")
      # expect(json["collection"]["items"][0]["data"][0]["prompt"]).to eq("Id")
    # end

    # it "returns the game's phase attribute" do
      # expect(json["collection"]["items"][0]["data"][1]["name"]).to eq("phase")
      # expect(json["collection"]["items"][0]["data"][1]["value"]).to eq("setup_players")
      # expect(json["collection"]["items"][0]["data"][1]["prompt"]).to eq("Phase")
    # end

    # it "returns the game's players association" do
      # expect(json["collection"]).to eq("phase")
    # end

    # it "creates a new game, with hypermedia to edit the first player" do
      # expect(json["links"]["players"].length).to eq(1)
    # end
  end
end
