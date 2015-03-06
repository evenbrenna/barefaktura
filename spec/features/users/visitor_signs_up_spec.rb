require 'rails_helper'

feature 'Visitor signs up' do
  scenario 'with valid information' do
    sign_up
    expect(page).to have_content('Velkommen! Din registrering er vellykket')
  end

  scenario 'with invalid email' do
    sign_up 'john.example.com'
    expect(page).to have_content('Epost er ugyldig')
  end

  scenario 'with non-matching password confirmation' do
    sign_up 'john@example.com', 'password', 'passord'
    expect(page).to have_content('Bekreft Passord passer ikke bekreftelsen')
  end

  scenario 'with blank password' do
    sign_up 'john@example.com', '', ''
    expect(page).to have_content('Passord må fylles ut')
  end

  scenario 'with blank email' do
    sign_up ''
    expect(page).to have_content('Epost må fylles ut')
  end

  # Helper methods
  def sign_up(email = 'john@example.com', password = 'password123', pass_conf = 'password123')
    visit new_user_registration_path

    fill_in 'Navn/Firma *',        :with => 'New Company'
    fill_in 'Vår Ref.',            :with => 'John Doe'
    fill_in 'Epost *',             :with => email
    fill_in 'Passord *',           :with => password
    fill_in 'Bekreft Passord *',  :with => pass_conf
    fill_in 'Adresse *',           :with => 'Olav Kyrres gt. 5005 Bergen'
    fill_in 'Telefon',             :with => '+ 47 999 999 999'
    fill_in 'Org.nr *',            :with => '999 999 999'
    check 'Registrert i Foretaksregisteret'
    check 'Registrert i Merverdiavgiftsregisteret'
    fill_in 'Neste fakturanummer', :with => '1'
    fill_in 'Bank *',              :with => 'Norges Bank AS'
    fill_in 'Kontonummer *',       :with => '6501.00.00000'
    fill_in 'SWIFT',               :with => ''
    fill_in 'IBAN',                :with => ''

    click_button 'Registrer Konto'
  end
end
