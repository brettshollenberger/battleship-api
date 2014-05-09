require 'spec_helper'

describe "Games API :" do
  describe "Create Action :" do
    before(:each) do
      post api_v1_games_path
    end

    it "is a successful request" do
      expect(response).to be_success
    end

    it "creates a new game, with hypermedia to edit the first player" do
      expect(json["links"]["players"].length).to eq(1)
    end
  end
end
