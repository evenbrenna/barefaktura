require 'faker'

FactoryGirl.define do
    factory :invoice_item do |f|
        association :invoice, factory: :invoice, strategy: :build
        f.description { Faker::Commerce.product_name }
        f.quantity { Faker::Commerce.price }
        f.unit { Faker::Lorem.word }
        f.unit_price { Faker::Commerce.price }
        f.vat 25
    end

    factory :item_125kr, parent: :invoice_item do |f|
        f.unit_price 100
        f.quantity 1
    end

end