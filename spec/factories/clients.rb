require 'faker'

FactoryGirl.define do
  factory :client do |f|
    association :user
    f.name { Faker::Company.name }
    f.address { Faker::Address.street_address }
    f.delivery_address { Faker::Address.street_address }
    f.email { Faker::Internet.email }
    f.ref { Faker::Name.name }
    f.org_nr { Faker::Number.number(9) }
  end
end
