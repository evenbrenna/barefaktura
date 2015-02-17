require 'spec_helper'
require 'rails_helper'

describe User do
  it 'has valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  it 'requires a name' do
    expect(FactoryGirl.build(:user, name: '')).to_not be_valid
  end

  it 'requires a valid email address' do
    expect(FactoryGirl.build(:user, email: '')).to_not be_valid
    expect(FactoryGirl.build(:user, email: 'even')).to_not be_valid
    expect(FactoryGirl.build(:user, email: 'user@test.com')).to be_valid
  end

  it 'requires an address' do
    expect(FactoryGirl.build(:user, address: '')).to_not be_valid
  end

  it 'requires an organisation number' do
    expect(FactoryGirl.build(:user, org_number: '')).to_not be_valid
  end

  it 'requires a bank name' do
    expect(FactoryGirl.build(:user, bank_name: '')).to_not be_valid
  end

  it 'requirea a bank account number' do
    expect(FactoryGirl.build(:user, bank_account: '')).to_not be_valid
  end

  it 'requires a valid next invoice number' do
    expect(FactoryGirl.build(:user, next_invoice_number: '')).to_not be_valid
    expect(FactoryGirl.build(:user, next_invoice_number: 'en')).to_not be_valid
    expect(FactoryGirl.build(:user, next_invoice_number: '1')).to be_valid
  end

  it "sets role to 'user' " do
    user = FactoryGirl.build(:user)
    expect(user.role).to eq('user')
  end

  it 'sends a welcome email when created' do
    user = FactoryGirl.build(:user)
    expect { user.save }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end
