require 'rails_helper'

# Required for logging in a user
include Warden::Test::Helpers
Warden.test_mode!

describe 'The clients page' do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user, scope: :user
  end

  it 'lets me add a new client, then displays it in the clients list.' do
    visit clients_path
    expect do
      click_link '+ Ny Kunde'
      fill_in 'Navn', with: 'Kunde Kundesen'
      fill_in 'Org.nr', with: '000000000'
      fill_in 'Adresse', with: 'Gate 23'
      fill_in 'Leveringsadresse', with: 'Gate 23'
      fill_in 'Epost', with: 'kunde@oddfowl.com'
      click_button 'Opprett Kunde'
    end.to change(Client, :count).by(1)
    expect(page).to have_content('Kunde Opprettet!')
    within 'h1' do
      expect(page).to have_content('Mine Kunder')
    end
    expect(page).to have_content('Kunde Kundesen')
    expect(page).to have_content('Gate 23')
    expect(page).to have_content('kunde@oddfowl.com')
  end

  it 'shows my clients details.' do
    client = FactoryGirl.create(:client, name: 'Kunde Kundemann', org_nr: '123456789')
    @user.clients << client
    visit clients_path
    expect(page).to have_content('Navn')
    expect(page).to have_content('Adresse')
    within("tr#client_#{client.id}") do
      click_link 'show'
    end
    within 'h1' do
      expect(page).to have_content('Kunde Kundemann')
    end
    expect(page).to have_content('123456789')
  end

  it 'lets me edit a client.' do
    client = FactoryGirl.create(:client, name: 'Test Kunde', address: 'Adresse 123')
    @user.clients << client
    visit clients_path
    within("tr#client_#{client.id}") do
      click_link 'edit'
    end
    fill_in 'Navn', with: ''
    click_button 'Oppdater'
    expect(page).to have_content('Navn må fylles ut')
    fill_in 'Navn', with: 'Test K. Unde'
    click_button 'Oppdater'
    within("tr#client_#{client.id}") do
      expect(page).to have_content('Test K. Unde')
    end
  end

  it "won't let me delete a client with invoices." do
    client = FactoryGirl.create(:client, name: 'Slett meg!', user: @user)
    @user.clients << client
    invoice = FactoryGirl.create(:invoice, user: @user, client: client)
    client.invoices << invoice
    visit clients_path
    expect(page).to have_content('Slett meg!')
    expect do
      within("tr#client_#{client.id}") do
        click_link 'delete'
      end
    end.to change(Client, :count).by(0)
    expect(page).to have_content('Feil: Du kan ikke slette en kunde som har motatt fakturaer')
  end

  it 'lets me delete a client.' do
    client = FactoryGirl.create(:client, name: 'Slett meg!', user: @user)
    @user.clients << client
    visit clients_path
    expect(page).to have_content('Slett meg!')
    expect do
      within("tr#client_#{client.id}") do
        click_link 'delete'
      end
    end.to change(Client, :count).by(-1)
    expect(page).to have_content('Kunde slettet')
  end
end
