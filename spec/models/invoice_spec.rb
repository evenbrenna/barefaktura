require 'rails_helper'

describe Invoice do
  # associations
  # =============

  it 'has a valid factory' do
    expect(FactoryGirl.create(:invoice)).to be_valid
  end

  it 'requires an associated user' do
    expect(FactoryGirl.build(:invoice, user_id: nil)).to_not be_valid
  end

  it 'requires an associated client' do
    expect(FactoryGirl.build(:invoice, client_id: nil)).to_not be_valid
  end

  it 'requires at least one associated item' do
    expect(FactoryGirl.build(:invoice, invoice_items_attributes: [])).to_not be_valid
  end

  # Validations
  # ===========

  it 'requires an invoice number' do
    expect(FactoryGirl.build(:invoice, invoice_number: nil)).to_not be_valid
  end

  it 'requires invoice number to be numerical' do
    expect(FactoryGirl.build(:invoice, invoice_number: '2012-12')).to_not be_valid
  end

  it 'requires a currency' do
    expect(FactoryGirl.build(:invoice, currency: nil)).to_not be_valid
  end

  it 'requires a delivery date' do
    expect(FactoryGirl.build(:invoice, delivery_date: nil)).to_not be_valid
  end

  it 'requires a due date' do
    expect(FactoryGirl.build(:invoice, due_date: nil)).to_not be_valid
  end

  it 'requires a client name' do
    expect(FactoryGirl.build(:invoice, client_name: nil)).to_not be_valid
  end

  it 'requires a client address' do
    expect(FactoryGirl.build(:invoice, client_address: nil)).to_not be_valid
  end

  it 'requires a delivery address' do
    expect(FactoryGirl.build(:invoice, delivery_address: nil)).to_not be_valid
  end

  it 'requires a user name' do
    expect(FactoryGirl.build(:invoice, user_name: nil)).to_not be_valid
  end

  it 'requires a user org number' do
    expect(FactoryGirl.build(:invoice, user_org_number: nil)).to_not be_valid
  end

  it 'requires a user email' do
    expect(FactoryGirl.build(:invoice, user_email: nil)).to_not be_valid
  end

  it 'requires a user bank name' do
    expect(FactoryGirl.build(:invoice, user_bank_name: nil)).to_not be_valid
  end

  it 'requires a user bank account' do
    expect(FactoryGirl.build(:invoice, user_bank_account: nil)).to_not be_valid
  end

  it 'requires a user address' do
    expect(FactoryGirl.build(:invoice, user_address: nil)).to_not be_valid
  end

  # methods and other
  # =================

  it 'calculates correct total before saving' do
    invoice = FactoryGirl.build(:invoice)
    invoice.invoice_items_attributes = []

    invoice_items = []
    3.times do # 3 items per invoice
      invoice_items << FactoryGirl.build(:invoice_item, unit_price: 10, quantity: 10, vat: 25)
    end
    invoice.invoice_items = invoice_items
    invoice.save
    expect(invoice.total).to eq(375)
  end

  it 'replicates correctly (for kreditnota) (checking total, user and client)' do
    invoice = FactoryGirl.create(:invoice)
    replica = invoice.replicate
    replica.save
    expect(invoice.total).to eq(replica.total)
    expect(invoice.client_id).to eq(replica.client_id)
    expect(invoice.user_id).to eq(replica.user_id)
  end
end
