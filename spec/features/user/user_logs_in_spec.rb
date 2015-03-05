require 'rails_helper'

feature 'user logs in' do
  before :each do
    @user = FactoryGirl.create(:user, :password => 'password123')
  end

  scenario 'from landing page vith valid credentials', :js => true do
    page.driver.allow_url('ajax.googleapis.com')
    page.driver.allow_url('fonts.googleapis.com')
    visit root_path
    click_button 'Logg inn'
    fill_in 'login-email', :with => @user.email
    fill_in 'Passord', :with => 'password123'
    click_button 'Logg Inn'
    expect(page).to have_content('Du er nå innlogget')
  end

  scenario 'from landing page vith invalid credentials', :js => true do
    page.driver.allow_url('ajax.googleapis.com')
    page.driver.allow_url('fonts.googleapis.com')
    visit root_path
    click_button 'Logg inn'
    fill_in 'login-email', :with => @user.email
    fill_in 'Passord', :with => 'invalid_password'
    click_button 'Logg Inn'
    expect(page).to have_content('Epostadresse eller passord er ikke gyldig.')
  end

  scenario 'from login page vith valid credentials' do
    visit new_user_session_path
    fill_in 'Epost', :with => @user.email
    fill_in 'Passord', :with => 'password123'
    check 'Husk meg'
    click_button 'Logg Inn'
    expect(page).to have_content('Du er nå innlogget.')
  end

  scenario 'from login page vith invalid credentials' do
    visit new_user_session_path
    fill_in 'Epost', :with => @user.email
    fill_in 'Passord', :with => 'invalid_password'
    check 'Husk meg'
    click_button 'Logg Inn'
    expect(page).to have_content('Epostadresse eller passord er ikke gyldig.')
  end
end
