# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :square do
    x 1
    y 1
    state "empty"
    board_id 1

    association :board
    association :game
  end
end
