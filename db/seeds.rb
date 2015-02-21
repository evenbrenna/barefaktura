# This file should contain all the record creation needed to seed the database
# with its default values. The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).

# Create Admin
admin = User.create(:name         => 'Administrator',
                    :email        => 'admin@example.com',
                    :password     => 'admin123',
                    :role         => 'administrator',
                    :address      => 'Amalie Skrams vei 26b, 5036 Bergen',
                    :phone        => '+47 988 36 856',
                    :org_number   => '123 456 789',
                    :bank_account => '6501 13 07 584',
                    :bank_name    => 'Nordea',
                    :ref          => 'Even Brenna')

# Create 5 Clients for Admin
5.times do |i|
  Client.create(:user_id          => admin.id,
                :name             => "Kunde ##{i}",
                :email            => "kunde#{i}@example.com",
                :org_nr           => "12345678#{i}",
                :ref              => "Kunde ##{i} Ref",
                :address          => "Portveien #{i}, 5050 Bergen",
                :delivery_address => "Portveien #{i}, 5050 Bergen")
end

# Create 5 Products for Admin
5.times do |i|
  Product.create(:user_id        => admin.id,
                 :product_number => i,
                 :description    => "Product ##{i}",
                 :unit           => 'stk',
                 :price          => i + 10.50,
                 :vat            => 25)
end
