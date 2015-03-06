require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'User edits a client' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
  end

  scenario 'with valid input' do
    client = FactoryGirl.create(
      :client, :name    => 'Test Kunde', :address => 'Adresse 123')
    @user.clients << client
    visit clients_path
    within("tr#client_#{client.id}") { click_link 'edit' }
    fill_in 'Navn', :with => 'Test K. Unde'
    click_button 'Oppdater'
    within("tr#client_#{client.id}") do
      expect(page).to have_content('Test K. Unde')
    end
  end

  scenario 'without required name' do
    client = FactoryGirl.create(
      :client, :name    => 'Test Kunde', :address => 'Adresse 123')
    @user.clients << client
    visit clients_path
    within("tr#client_#{client.id}") { click_link 'edit' }
    fill_in 'Navn', :with => ''
    click_button 'Oppdater'
    expect(page).to have_content('Navn må fylles ut')
  end
end
