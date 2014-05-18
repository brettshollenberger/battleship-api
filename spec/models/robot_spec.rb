require 'spec_helper'

describe Robot do
  before(:each) do
    @game  = FactoryGirl.create(:game, :with_robot_enemy)
    @robot = @game.players.last
  end

  it "sets the robot's name" do
    expect(@robot.name).to eq("Pip")
  end

  it "sets the robot's brain" do
    expect(@robot.brain).to eq(:pip)
  end

  it "uses the robot's set_ships ability" do
    @robot.set_ships_for(@game)
    expect(@robot.ships_for(@game).set?).to eq(true)
  end
end
