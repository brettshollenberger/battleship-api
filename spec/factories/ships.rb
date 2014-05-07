# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship do
    board_id 1
    kind "battleship"
    square_id 1
    state "unset"

    association :board
    association :square
  end
end
