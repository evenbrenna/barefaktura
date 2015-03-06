require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'User shows client' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
  end

  scenario 'all clients details are shown' do
    client = FactoryGirl.create(:client, :name   => 'Kunde Kundemann',
                                         :org_nr => '123456789')
    @user.clients << client

    visit clients_path
    expect(page).to have_content('Navn')
    expect(page).to have_content('Adresse')

    within("tr#client_#{client.id}") { click_link 'show' }
    within 'h1' do
      expect(page).to have_content('Kunde Kundemann')
    end
    expect(page).to have_content('123456789')
  end
end
