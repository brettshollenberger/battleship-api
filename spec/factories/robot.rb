FactoryGirl.define do
  factory :robot, class: Robot do
    skip_create

    name "Pip"
  end
end
