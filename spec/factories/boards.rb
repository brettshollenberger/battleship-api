# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :board do
    game_id 1
    player_id 1
    association :game
    association :player
  end
end
