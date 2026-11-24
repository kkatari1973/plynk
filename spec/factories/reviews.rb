FactoryBot.define do
  factory :review do
    association :user
    association :item
    rating { 5 }
    body { "A great recommendation!" }
  end
end
