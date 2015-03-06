require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'User deletes a client' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
    @client = FactoryGirl.create(
      :client, :name => 'Slett meg!', :user => @user)
    @user.clients << @client
  end

  scenario 'success if user has no invoices' do
    visit clients_path
    expect(page).to have_content('Slett meg!')
    expect do
      within("tr#client_#{@client.id}") do
        click_link 'delete'
      end
    end.to change(@user.clients, :count).by(-1)
    expect(page).to have_content('Kunde slettet')
  end

  scenario 'gets error if client has invoices' do
    invoice = FactoryGirl.create(
      :invoice, :user => @user, :client => @client)
    @client.invoices << invoice
    visit clients_path
    expect(page).to have_content('Slett meg!')
    expect do
      within("tr#client_#{@client.id}") do
        click_link 'delete'
      end
    end.to change(@user.clients, :count).by(0)
    expect(page).to have_content(
      'Du kan ikke slette en kunde som har motatt fakturaer')
  end
end
