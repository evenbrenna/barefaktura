require 'faker'

FactoryGirl.define do
    factory :product do |f|
        association :user
        f.product_number { Faker::Number.number(3) }
        f.description { Faker::Commerce.product_name }
        f.unit { Faker::Lorem.word }
        f.price { Faker::Number.number(3) }
        f.vat 25
    end

    factory :invalid_product, parent: :product do |f|
        f.description nil
    end
end
