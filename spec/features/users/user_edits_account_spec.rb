require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'User edits account' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
  end

  scenario 'with valid information' do
    visit invoices_path
    click_link 'Min Profil'
    click_link 'Rediger Profil'
    expect(page).to have_field('Adresse *', :with => @user.address)
    fill_in 'Adresse *', :with => 'Ny Adresse 23, 0000 Nytt Sted'
    fill_in 'Ditt Passord *', :with => @user.password
    click_button 'Oppdater'
    expect(page).to have_content('Din profil er oppdatert')
    click_link 'Min Profil'
    expect(page).to have_content('Ny Adresse 23, 0000 Nytt Sted')
  end

  scenario 'and changes password' do
    visit invoices_path
    click_link 'Min Profil'
    click_link 'Rediger Profil'
    fill_in 'Passord', :with => 'nyttpassord'
    fill_in 'Bekreft Passord', :with => 'nyttpassord'
    fill_in 'Ditt Passord *', :with => @user.password
    click_button 'Oppdater'
    expect(page).to have_content('Din profil er oppdatert')
    click_link 'Min Profil'
    click_link 'Rediger Profil'
    fill_in 'Adresse *', :with => 'Ny Adresse 23, 0000 Nytt Sted'
    fill_in 'Ditt Passord *', :with => 'nyttpassord'
    click_button 'Oppdater'
    expect(page).to have_content('Din profil er oppdatert')
    click_link 'Min Profil'
    expect(page).to have_content('Ny Adresse 23, 0000 Nytt Sted')
  end

  scenario 'without entering password' do
    visit invoices_path
    click_link 'Min Profil'
    click_link 'Rediger Profil'
    expect(page).to have_field('Adresse *', :with => @user.address)
    fill_in 'Adresse *', :with => 'Ny Adresse 23, 0000 Nytt Sted'
    click_button 'Oppdater'
    expect(page).to have_content('Ditt passord må fylles ut')
  end
end
