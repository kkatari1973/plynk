FactoryBot.define do
  factory :item do
    sequence(:title) { |n| "Item #{n}" }
    association :category
  end
end