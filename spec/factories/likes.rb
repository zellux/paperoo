# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :like do
    likeable nil
    user_id 1
  end
end
