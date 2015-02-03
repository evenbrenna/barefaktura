require 'faker'

FactoryGirl.define do
    factory :invoice do |f|
        association :user
        association :client
        f.invoice_number { Faker::Number.number(3) }
        f.currency "kr"
        f.delivery_date { Faker::Date.between(2.days.ago, Date.today) }
        f.due_date { Faker::Date.forward(31) }
        f.client_name { Faker::Name.name }
        f.client_address { Faker::Address.street_address }
        f.delivery_address { Faker::Address.street_address }
        f.user_name { Faker::Name.name }
        f.user_org_number { Faker::Number.number(9) }
        f.user_email { Faker::Internet.email }
        f.user_bank_name { Faker::Company.name }
        f.user_bank_account { Faker::Number.number(11) }
        f.user_address { Faker::Address.street_address }

        before(:create) do |invoice|
            invoice_items = []
            3.times do # 3 items per invoice
                invoice_items << build(:invoice_item)
            end
            invoice.invoice_items = invoice_items
        end
    end

    factory :invoice375, parent: :invoice do |f|
        before(:create) do |invoice|
            invoice_items = []
            3.times do # 3 items per invoice
                invoice_items << build(:item_125kr)
            end
            invoice.invoice_items = invoice_items
        end
    end

    factory :kreditnota125, parent: :invoice do |f|
        f.kreditnota true
        before(:create) do |invoice|
            invoice_items = []
            1.times do # 1 items per invoice
                invoice_items << build(:item_125kr)
            end
            invoice.invoice_items = invoice_items
        end
    end
end