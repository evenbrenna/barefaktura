require 'rails_helper'

describe InvoiceItem do
  # associations
  # =============

  it 'has a valid factory' do
    expect(FactoryGirl.create(:invoice_item)).to be_valid
  end

  it 'requires an associated invoice' do
    expect(FactoryGirl.build(:invoice_item, invoice_id: nil)).to_not be_valid
  end

  # validations
  # ===========

  it 'requires a description' do
    expect(FactoryGirl.build(:invoice_item, description: nil)).to_not be_valid
  end

  it 'requires a quantity' do
    expect(FactoryGirl.build(:invoice_item, quantity: nil)).to_not be_valid
  end

  it 'requires quantity to be numerical' do
    expect(FactoryGirl.build(:invoice_item, quantity: 'quantity')).to_not be_valid
  end

  it 'requires a price' do
    expect(FactoryGirl.build(:invoice_item, unit_price: nil)).to_not be_valid
  end

  it 'requires price to be numerical' do
    expect(FactoryGirl.build(:invoice_item, unit_price: 'price')).to_not be_valid
  end

  it 'accepts max two decimals for price' do
    expect(FactoryGirl.build(:invoice_item, unit_price: '1.11')).to be_valid
    expect(FactoryGirl.build(:invoice_item, unit_price: '1.111')).to_not be_valid
  end

  it 'requires a vat rate' do
    expect(FactoryGirl.build(:invoice_item, vat: nil)).to_not be_valid
  end

  it 'requires vat to be numerical' do
    expect(FactoryGirl.build(:invoice_item, vat: 'vat')).to_not be_valid
  end

  it 'accepts one or two digits for vat' do
    expect(FactoryGirl.build(:invoice_item, vat: '1')).to be_valid
    expect(FactoryGirl.build(:invoice_item, vat: '11')).to be_valid
    expect(FactoryGirl.build(:invoice_item, vat: '111')).to_not be_valid
  end

  # substitutions
  # =============

  it 'accepts , and strips blanks for quantity' do
    expect(FactoryGirl.build(:invoice_item, quantity: '10 000,00').quantity.to_f).to eq(10_000.00)
  end

  it 'accepts , and strips blanks for price' do
    expect(FactoryGirl.build(:invoice_item, unit_price: '10 000,00').unit_price.to_f).to eq(10_000.00)
  end
end
