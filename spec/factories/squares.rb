# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :square do
    x 1
    y 1
    state "MyString"
    board_id 1
  end
end
