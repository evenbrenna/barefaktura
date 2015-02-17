require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.name { Faker::Company.name }
    f.ref { Faker::Name.name }
    f.password { Faker::Internet.password(8, 99) }
    f.phone { Faker::PhoneNumber.phone_number }
    f.email { Faker::Internet.email }
    f.address { Faker::Address.street_address }
    f.org_number { Faker::Number.number(9) }
    f.bank_name { Faker::Number.number(9) }
    f.bank_account { Faker::Number.number(9) }
    f.next_invoice_number { Faker::Number.number(3) }
  end
end
