# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :games_player, :class => 'GamesPlayers' do
    player_id 1
    game_id 1
  end
end
