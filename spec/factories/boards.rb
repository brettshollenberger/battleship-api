# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :board do
    association :game
  end
end
