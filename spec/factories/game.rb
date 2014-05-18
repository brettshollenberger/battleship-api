# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    phase "setup_players"

    trait :with_players do
      after(:create) do |game|
        2.times { game.players.create(:name => "Brett") }
      end
    end
  end
end
