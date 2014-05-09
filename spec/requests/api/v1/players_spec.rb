require 'spec_helper'

describe "Players API :" do
  describe "Edit Action :" do
    before(:each) do
      @game = FactoryGirl.create(:game)
      @p1   = @game.players.first
      @p2   = @game.players.last
    end

    describe "At the beginning of a new game :" do
      before(:each) do
        put api_v1_player_path(@p1)
      end

      it "is a successful request" do
        expect(response).to be_success
      end

      it "creates a new game, with hypermedia to edit the first player" do
        expect(json["links"]["players"].length).to eq(1)
      end
    end
  end
end
