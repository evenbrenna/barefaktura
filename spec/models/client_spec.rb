require 'spec_helper'
require 'rails_helper'

describe Client do

    it "has valid factory" do
        expect(FactoryGirl.create(:client)).to be_valid
    end

    it "requires an associated user" do
        expect(FactoryGirl.build(:client, :user_id => "")).to_not be_valid
    end

    it "requires a name" do
        expect(FactoryGirl.build(:client, :name => "")).to_not be_valid
    end

    it "requires an address" do
        expect(FactoryGirl.build(:client, :address => "")).to_not be_valid
    end

    it "requires a delivery address" do
        expect(FactoryGirl.build(:client, :delivery_address => "")).to_not be_valid
    end

    it "cannot be deleted if it has associated invoices" do
        client = FactoryGirl.build(:client)
        invoice = FactoryGirl.build(:invoice)
        client.invoices << invoice
        expect { client.destroy }.to raise_error
    end

end
