# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship do
    board_id 1
    type ""
    square_id 1
    state "MyString"
  end
end
