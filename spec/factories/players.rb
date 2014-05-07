# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :player do
    name "Brett"
    games { [FactoryGirl.create(:game)] }
  end
end
