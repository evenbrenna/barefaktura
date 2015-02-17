require 'spec_helper'
require 'rails_helper'

describe InvoicesController do

    before :each do
        # to avoid having it converting to pdf every time this test runs
        allow_any_instance_of(WickedPdf).to receive(:pdf_from_string).and_return("pdf converted invoice")

        # create a user and sign in
        @user = FactoryGirl.create(:user)
        sign_in @user
    end

    it "redirects to login page if user is guest" do
        sign_out @user
        get :index
        expect(response).to redirect_to new_user_session_path
    end

    describe "GET #index" do

        it "assigns the current user to @user" do
            get :index, id: @user
            expect(assigns(:user)).to eq(@user)
        end

        it "populates an array of invoices" do
            invoice = FactoryGirl.create(:invoice)
            @user.invoices << invoice
            get :index
            expect(assigns(:invoices)).to eq(@user.invoices)
        end

        it "renders the :index view" do
            get :index
            expect(response).to render_template(:index)
        end
    end

    describe "GET #show" do

        before :each do
            @invoice = FactoryGirl.create(:invoice)
        end

        it "assigns the requested invoice to @invoice" do
            @user.invoices << @invoice
            get :show, id: @invoice
            expect(assigns(:invoice)).to eq(@invoice)
        end

        it "renders the :show view (html)" do
            @user.invoices << @invoice
            get :show, id: @invoice
            expect(response).to render_template(:show)
        end

        it "renders the :show view (pfd)" do
            @user.invoices << @invoice
            get :show, id: @invoice, format: 'pdf'
            expect(response).to render_template(:show)
        end

        it "raises error if user is not owner of invoice" do
            expect{get :show, id: @invoice}.to raise_error(CanCan::AccessDenied)
        end
    end

    describe "GET #new" do

        it "assigns the current user to @user" do
            get :new, id: @user
            expect(assigns(:user)).to eq(@user)
        end

        it "assigns a new invoice to @invoice" do
            get :new
            expect(assigns(:invoice)).to be_a_new(Invoice)
        end

        it "assigns @invoice to current user" do
            get :new
            expect(assigns(:invoice).user_id).to eq(@user.id)
        end

        it "assigns @user saved clients to @client_list" do
            client = FactoryGirl.create(:client)
            @user.clients << client
            get :new
            expect(assigns(:client_list)).to eq(@user.clients.map { |c| [c.name, c.id] })
        end

        it "assigns a new invoice_item to @invoice" do
            get :new
            expect(assigns(:invoice).invoice_items.first).to be_a_new(InvoiceItem)
        end

        it "assigns @user saved products to @products" do
            product = FactoryGirl.create(:product)
            @user.products << product
            get :new
            expect(assigns(:products)).to eq(@user.products)
        end

        it "sets @invoice.invoice_number to @user.next_invoice_number" do
            get :new
            expect(assigns(:invoice).invoice_number).to eq(@user.next_invoice_number)
        end

        it "renders the :new view" do
            expect(get :new).to render_template(:new)
        end
    end

    describe "POST #create" do

        context "with valid attributes" do


            it "assigns user details to invoice" do
                post :create, invoice: FactoryGirl.attributes_for(:invoice).merge(
                    invoice_items_attributes: [ FactoryGirl.attributes_for(:invoice_item) ])
                expect(Invoice.last.user_name).to eq(@user.name)
                expect(Invoice.last.user_address).to eq(@user.address)
            end

            it "creates new client assigned to user if client_id is blank" do
                expect{post :create, invoice: FactoryGirl.attributes_for(:invoice).merge(
                    invoice_items_attributes: [FactoryGirl.attributes_for(:invoice_item) ])
                    }.to change(@user.clients, :count).by(1)
            end

            it "saves the correct data for the new user" do
                post :create, invoice: FactoryGirl.attributes_for(:invoice, client_name: "Even").merge(
                    invoice_items_attributes: [FactoryGirl.attributes_for(:invoice_item) ])
                expect(@user.clients.last.name).to eq("Even")
            end

            it "assigns the new client to the invoice" do
                post :create, invoice: FactoryGirl.attributes_for(:invoice).merge(
                    invoice_items_attributes: [ FactoryGirl.attributes_for(:invoice_item) ])
                expect(Invoice.last.client_id).to eq(Client.last.id)
            end

            it "saves the new invoice to the database" do
                expect{post :create, invoice: FactoryGirl.attributes_for(:invoice).merge(
                    invoice_items_attributes: [FactoryGirl.attributes_for(:invoice_item) ])
                    }.to change(Invoice, :count).by(1)
            end

            it "increments @user.next_invoice_number on save" do
                now = @user.next_invoice_number
                post :create, invoice: FactoryGirl.attributes_for(:invoice, user: @user, invoice_number: @user.next_invoice_number).merge(
                    invoice_items_attributes: [FactoryGirl.attributes_for(:invoice_item) ])
                expect(assigns(:user).next_invoice_number).to eq(now + 1)
            end

            it "redirects to the :show view" do
                post :create, invoice: FactoryGirl.attributes_for(:invoice).merge(
                    invoice_items_attributes: [ FactoryGirl.attributes_for(:invoice_item) ])
                expect(response).to redirect_to(:action => :show, :id => assigns(:invoice).id)
            end
        end

        context "with invalid attributes" do

            it "does not save the new invoice to the database" do
                expect{post :create, invoice: FactoryGirl.attributes_for(:invoice, invoice_number: nil).merge(
                    invoice_items_attributes: [FactoryGirl.attributes_for(:invoice_item) ])
                    }.to change(Invoice, :count).by(0)
            end

            it "re-renders the :new view" do
                post :create, invoice: FactoryGirl.attributes_for(:invoice, invoice_number: nil).merge(
                    invoice_items_attributes: [ FactoryGirl.attributes_for(:invoice_item) ])
                expect(response).to render_template(:new)
            end
        end
    end

    describe "GET #email_invoice" do

        before :each do
            @invoice = FactoryGirl.create(:invoice)
            @user.invoices << @invoice
        end

        it "assigns current user to @user" do
            xhr :get, :email_invoice, id: @invoice.id
            expect(assigns(:user)).to eq(@user)
        end

        it "assigns requested invoice to @invoice" do
            xhr :get, :email_invoice, id: @invoice.id
            expect(assigns(:invoice)).to eq(@invoice)
        end

        it "assigns invoice.client to @client" do
            client = FactoryGirl.create(:client)
            @invoice.update_attribute(:client_id, client.id)
            xhr :get, :email_invoice, id: @invoice.id
            expect(assigns(:client)).to eq(client)
        end

        it "assigns correct type to @type when invoice" do
            xhr :get, :email_invoice, id: @invoice.id
            expect(assigns(:type)).to eq('faktura')
        end

        it "assigns correct type to @type when kreditnota" do
            invoice = FactoryGirl.create(:invoice, kreditnota: true)
            @user.invoices << invoice
            xhr :get, :email_invoice, id: invoice.id
            expect(assigns(:type)).to eq('kreditnota')
        end

        it "renders the :email_invoice view" do
            xhr :get, :email_invoice, id: @invoice.id
            expect(response).to render_template(:email_invoice)
        end
    end

    describe "POST #send_email_invoice" do

        before :each do
            @invoice = FactoryGirl.create(:invoice)
            @user.invoices << @invoice
        end

        it "assigns the requested invoice to @invoice" do
            post :send_email_invoice, id: @invoice.id
            expect(assigns(:invoice)).to eq(@invoice)
        end

        it "sends an email" do
            expect { post :send_email_invoice, id: @invoice.id }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "increments sends attribute for @invoice" do
            now = @invoice.sends
            post :send_email_invoice, id: @invoice.id
            expect(assigns(:invoice).sends).to eq(now + 1)
        end

        it "redirects to :index view" do
            post :send_email_invoice, id: @invoice.id
            expect(response).to redirect_to(invoices_path)
        end
    end

    describe "GET #set_paid" do

        before :each do
            @invoice = FactoryGirl.create(:invoice, paid: false)
            @user.invoices << @invoice
        end

        it "assigns requested invoice to @invoice" do
            @request.env['HTTP_REFERER'] = "/"
            get :set_paid, id: @invoice.id
            expect(assigns(:invoice)).to eq(@invoice)
        end

        it "updates the attribute for @invoice" do
            @request.env['HTTP_REFERER'] = "/"
            expect(@invoice.paid).to eq(false)
            get :set_paid, {id: @invoice.id, paid: true}
            expect(assigns(:invoice).paid).to eq(true)
        end

        it "redirects to :back" do
            @request.env['HTTP_REFERER'] = "/"
            get :set_paid, id: @invoice.id
            expect(response).to redirect_to("/")
        end
    end

    describe "GET #kreditnota" do

        before :each do
            @invoice = FactoryGirl.create(:invoice)
            @user.invoices << @invoice
        end

        it "assigns current user to @user" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:user)).to eq(@user)
        end

        it "assigns the requested invoice to @invoice_to_credit" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:invoice_to_credit)).to eq(@invoice)
        end

        it "assigns a duplicate to @invoice" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:invoice)).to be_a_new(Invoice)
        end

        it "duplicates invoice_items" do
            get :kreditnota, id: @invoice.id
            assigns(:invoice).save
            expect(assigns(:invoice).invoice_items.count).to eq(assigns(:invoice_to_credit).invoice_items.count)
        end

        it "sets a default note to @invoice" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:invoice).notes).to include("Kreditnota for faktura")
        end

        it "sets @invoice.kreditnota to true" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:invoice).kreditnota).to eq(true)
        end

        it "sets @invoice.invoice_number to @user.next_invoice_number" do
            get :kreditnota, id: @invoice.id
            expect(assigns(:invoice).invoice_number).to eq(@user.next_invoice_number)
        end
    end
end