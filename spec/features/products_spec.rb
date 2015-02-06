require 'spec_helper'
require 'rails_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "Products" do

    describe "Manage products" do

        before :each do
            @user = FactoryGirl.create(:user)
            login_as @user, scope: :user
        end

        it "adds a new product and displays it in products#index" do
            visit products_url
            expect {
                click_link "+ Nytt Produkt"
                fill_in 'Produktnummer', with: "A01"
                fill_in 'Beskrivelse', with: "Et fantastisk produkt"
                fill_in 'Enhet', with: "stk"
                fill_in 'Pris per enhet', with: "100"
                select "25", :from => "MVA"
                click_button "Opprett Produkt"
            }.to change(Product, :count).by(1)
            expect(page).to have_content("Produkt er opprettet!")
            within 'h1' do
                expect(page).to have_content("Mine Produkter")
            end
            expect(page).to have_content("A01")
            expect(page).to have_content("Et fantastisk produkt")
            expect(page).to have_content("stk")
            expect(page).to have_content("100")
            expect(page).to have_content("25 %")
        end

        it "shows product details" do
            product = FactoryGirl.create(:product, description: "Produkt", unit: "Kilo")
            @user.products << product
            visit products_url
            expect(page).to have_content("Produkt")
            expect(page).to have_content("Kilo")
            within("tr#product_#{product.id}") do
                click_link "show"
            end
            within 'h1' do
                expect(page).to have_content("Produkt ##{product.product_number}")
            end
            expect(page).to have_content("Beskrivelse:")
            expect(page).to have_content("Produkt")
            expect(page).to have_content("Enhet:")
            expect(page).to have_content("Kilo")
        end

        it "edits a product" do
            product = FactoryGirl.create(:product, description: "Produkt", unit: "Kilo")
            @user.products << product
            visit products_url
            within("tr#product_#{product.id}") do
                click_link "edit"
            end
            fill_in 'Beskrivelse', with: ""
            click_button "Oppdater Produkt"
            expect(page).to have_content("Beskrivelse må fylles ut")
            fill_in 'Beskrivelse', with: "Et fantastisk produkt"
            click_button "Oppdater Produkt"
            within("tr#product_#{product.id}") do
                expect(page).to have_content("Et fantastisk produkt")
            end
        end

        it "deletes a product" do
            product = FactoryGirl.create(:product, description: "Slett meg!")
            @user.products << product
            visit products_url
            expect(page).to have_content("Slett meg!")
            expect{
                within("tr#product_#{product.id}") do
                    click_link "delete"
                end
            }.to change(Product, :count).by(-1)
            expect(page).to_not have_content("Slett meg!")
        end
    end
end