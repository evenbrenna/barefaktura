require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

feature 'User creates client' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, :scope => :user
  end

  scenario 'with valid input in all fields' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn',             :with => 'Kunde Kundesen'
      fill_in 'Org.nr',           :with => '999 999 999'
      fill_in 'Adresse',          :with => 'Gate 23'
      fill_in 'Leveringsadresse', :with => 'Gate 24'
      fill_in 'Epost',            :with => 'kunde@kundesen.com'
      click_button 'Opprett Kunde'
    end.to change(@user.clients, :count).by(1)
    expect(page).to have_content('Kunde Opprettet!')
    within 'h1' do
      expect(page).to have_content('Kunder')
    end
    expect(page).to have_content('Kunde Kundesen')
    expect(page).to have_content('Gate 23')
    expect(page).to have_content('kunde@kundesen.com')
  end

  scenario 'with valid input in only required fields' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn',             :with => 'Kunde Kundesen'
      fill_in 'Org.nr',           :with => ''
      fill_in 'Adresse',          :with => 'Gate 23'
      fill_in 'Leveringsadresse', :with => 'Gate 24'
      fill_in 'Epost',            :with => ''
      click_button 'Opprett Kunde'
    end.to change(@user.clients, :count).by(1)
    expect(page).to have_content('Kunde Opprettet!')
    within 'h1' do
      expect(page).to have_content('Kunder')
    end
    expect(page).to have_content('Kunde Kundesen')
    expect(page).to have_content('Gate 23')
  end

  scenario 'without required name' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn',             :with => ''
      fill_in 'Org.nr',           :with => ''
      fill_in 'Adresse',          :with => 'Gate 23'
      fill_in 'Leveringsadresse', :with => 'Gate 23'
      fill_in 'Epost',            :with => ''
      click_button 'Opprett Kunde'
    end.to change(@user.clients, :count).by(0)
    expect(page).to have_content('Navn må fylles ut')
  end

  scenario 'without required address' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn',             :with => 'Kunde Kundesen'
      fill_in 'Org.nr',           :with => ''
      fill_in 'Adresse',          :with => ''
      fill_in 'Leveringsadresse', :with => 'Gate 23'
      fill_in 'Epost',            :with => ''
      click_button 'Opprett Kunde'
    end.to change(@user.clients, :count).by(0)
    expect(page).to have_content('Adresse må fylles ut')
  end

  scenario 'without required delivery address' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn',             :with => 'Kunde Kundesen'
      fill_in 'Org.nr',           :with => ''
      fill_in 'Adresse',          :with => 'Gate 23'
      fill_in 'Leveringsadresse', :with => ''
      fill_in 'Epost',            :with => ''
      click_button 'Opprett Kunde'
    end.to change(@user.clients, :count).by(0)
    expect(page).to have_content('Leveringsadresse må fylles ut')
  end
end
