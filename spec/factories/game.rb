# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    phase "setup_players"

    trait :with_players do
      after(:create) do |game|
        2.times { game.players.create(:name => "Brett") }
      end
    end

    trait :with_robot_enemy do
      after(:create) do |game|
        game.players.create(:name => "Brett")
        game.players.create(:brain => :pip)
      end
    end
  end
end
