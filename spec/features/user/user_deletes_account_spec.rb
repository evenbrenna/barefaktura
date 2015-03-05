require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'user deletes account' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
  end

  scenario 'without providing password (should delete)' do
    visit invoices_path
    expect(page).to have_content('Logg Ut')
    click_link 'Min Profil'
    click_link 'Rediger Profil'
    click_link 'Slett Konto'
    expect(page).to have_content('Opprett konto')
  end
end
