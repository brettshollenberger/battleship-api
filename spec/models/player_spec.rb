require 'spec_helper'

describe Player do
  let(:player) { FactoryGirl.create(:player) }

  it "is valid" do
    expect(player).to be_valid
  end

  it "is not setup without a name" do
    expect(player.setup?).to be_true
    player.name = ""
    expect(player.setup?).to be_false
  end
end
