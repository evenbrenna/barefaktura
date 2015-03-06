require 'rails_helper'

feature 'User resets password' do
  scenario 'with valid email address' do
    user = FactoryGirl.create(:user)
    visit new_user_session_path
    click_link 'Glemt Passord?'
    fill_in 'Epost', :with => user.email
    click_button 'Reset Passord'
    expect(page).to have_content(
      'Du vil innen få minutter motta en epost med
      instruksjoner for å nullstille passordet ditt.')
  end

  scenario 'with unknown email address' do
    visit new_user_session_path
    click_link 'Glemt Passord?'
    fill_in 'Epost', :with => 'unknown@example.com'
    click_button 'Reset Passord'
    expect(page).to have_content('Epost ikke funnet')
  end
end
