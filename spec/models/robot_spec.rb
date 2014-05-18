require 'spec_helper'

describe Robot do
  before(:each) do
    @game = FactoryGirl.create(:game, :with_robot_enemy)
  end
end
