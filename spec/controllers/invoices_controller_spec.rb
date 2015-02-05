require 'spec_helper'
require 'rails_helper'

describe InvoicesController do

    before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
    end

    it "redirects to login page if user is guest" do
        sign_out @user
        get :index
        expect(response).to redirect_to new_user_session_path
    end

    describe "GET #index" do

        it "assigns the current user to @user"
        it "populates an array of invoices"
        it "renders the :index view"
    end

    describe "GET #show" do

        it "assigns the requested invoice to @invoice"
        it "renders the :show view (html)"
        it "generates the :show view (pfd)"
        it "raises error if user is not owner of invoice"
    end

    describe "GET #new" do

        it "assigns the current user to @user"
        it "assigns a new invoice to @invoice"
        it "assigns @invoice to current user"
        it "assigns @user saved clients to @client_list"
        it "assigns a new invoice_item to @invoice"
        it "assigns @user saved products to @products"
        it "sets @invoice.invoice_number to @user.next_invoice_number"
        it "renders the :new view"
    end

    describe "POST #create" do

        context "with valid attributes" do

            it "assigns user details to invoice"
            it "creates new client if client_id is blank"
            it "assigns the new client to the invoice"
            it "saves the new invoice to the database"
            it "increments @user.next_invoice_number on save"
            it "redirects to the :index view"
        end

        context "with invalid attributes" do

            it "does not save the new invoice to the database"
            it "re-renders the :new view"
        end
    end

    describe "GET #email_invoice" do

        it "assigns current user to @user"
        it "assigns requested invoice to @invoice"
        it "assigns invoice.client to @client"
        it "assigns correct type to @type"
        it "renders the :email_invoice view"
    end

    describe "POST #send_email_invoice" do

        it "assigns the requested invoice to @invoice"
        it "sends an email"
        it "increments sends attribute for @invoice"
        it "redirects to :index view"
    end

    describe "GET #set_paid" do

        it "assigns requested invoice to @invoice"
        it "updates the attribute for @invoice"
        it "redirects to :back"
    end

    describe "GET #kreditnota" do

        it "assigns current user to @user"
        it "assigns the requested invoice to @invoice_to_credit"
        it "assigns a duplicate to @invoice"
        it "duplicates invoice_items"
        it "sets a default note to @invoice"
        it "sets @invoice.kreditnota to true"
        it "sets @invoice.invoice_number to @user.next_invoice_number "
    end
end