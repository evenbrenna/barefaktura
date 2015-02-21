require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

describe 'The invoices page' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, scope: :user
  end

  it 'lets me create a new invoice, redirects to show', :js => true do
    # Supress capybara-webkit warnings
    page.driver.allow_url('ajax.googleapis.com')
    page.driver.allow_url('fonts.googleapis.com')

    visit invoices_path
    click_link '+ Ny Faktura'

    # Client details
    fill_in 'Navn *', with: 'Kunde Navn'
    fill_in 'Epost', with: 'kunte@test.no'
    fill_in 'Adresse *', with: 'Gate 123, 1234 Byen'
    fill_in 'Leveringsadresse *', with: 'Gate 123, 1234 Byen'

    # Expect required invoice number, delivery date and due date
    # to have been filled in automatically

    # Item 1
    within :css, 'div#item_1' do
      fill_in 'Antall *', with: '1'
      fill_in 'Enhet (timer, kg, ...) *', with: '1'
      fill_in 'Beskrivelse *', with: 'Produkt 1'
      fill_in 'Pris per enhet *', with: '12,5'
      select '0%', from: 'MVA *'
    end

    click_button '+ Legg til produkt/tjeneste'

    # Item 2
    within :css, 'div#item_2' do
      fill_in 'Antall *', with: '1'
      fill_in 'Enhet (timer, kg, ...) *', with: '1'
      fill_in 'Beskrivelse *', with: 'Produkt 2'
      fill_in 'Pris per enhet *', with: '12.5'
      select '25%', from: 'MVA *'
    end

    click_button '+ Legg til produkt/tjeneste'

    # Item 3
    within :css, 'div#item_3' do
      fill_in 'Antall *', with: '0,5'
      fill_in 'Enhet (timer, kg, ...) *', with: 'timer'
      fill_in 'Beskrivelse *', with: 'Produkt 3'
      fill_in 'Pris per enhet *', with: '99,90'
      select '25%', from: 'MVA *'
    end

    click_button 'Lagre'

    # Confirmation dialog
    expect(page).to have_content('Er du sikker på at alle felt
                                    er korrekt utfyllt?')
    click_link 'Ok'

    # Expect to have been redirected to the :show view for the new invoice
    expect(page).to have_content(@user.name.split.map(&:capitalize).join(' '))
    expect(page).to have_content('Produkt 1')
    expect(page).to have_content('Produkt 2')
    expect(page).to have_content('Produkt 3')
    expect(page).to have_content('Totalt å betale')
  end
end
