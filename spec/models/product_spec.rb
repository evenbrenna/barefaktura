require 'rails_helper'

describe Product do
  # Validations
  # ===========

  it 'has valid factory' do
    expect(FactoryGirl.create(:product)).to be_valid
  end

  it 'requires an associated user' do
    expect(FactoryGirl.build(:product, user_id: '')).to_not be_valid
  end

  it 'requires a description' do
    expect(FactoryGirl.build(:product, description: '')).to_not be_valid
  end

  it 'requires a valid price' do
    expect(FactoryGirl.build(:product, price: '')).to_not be_valid
    expect(FactoryGirl.build(:product, price: 'pris')).to_not be_valid
  end

  it 'requires a vat' do
    expect(FactoryGirl.build(:product, vat: '')).to_not be_valid
  end

  it 'requires a product number' do
    expect(FactoryGirl.build(:product, product_number: '')).to_not be_valid
  end

  # Methods
  # =======

  it 'strips blanks and accepts comma as decimal separator for price' do
    expect(FactoryGirl.build(:product, price: '10 000,00').price.to_f).to eq(10_000.00)
  end

  it 'returns product number and description as a string' do
    product = FactoryGirl.build(:product, description: 'desc', product_number: 'AA001')
    expect(product.product_with_number).to eq('[AA001] desc')
  end
end
