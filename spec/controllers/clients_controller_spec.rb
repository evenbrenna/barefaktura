require 'spec_helper'
require 'rails_helper'

describe ClientsController do
  describe 'GET #index' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'assigns the current user to @user' do
        get :index, id: @user
        expect(assigns(:user)).to eq(@user)
      end

      it 'populates an array of clients' do
        client = FactoryGirl.create(:client)
        @user.clients << client
        get :index
        expect(assigns(:clients)).to eq(@user.clients)
      end

      it 'renders the :index view' do
        get :index
        expect(response).to render_template :index
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @client = FactoryGirl.create(:client)
      end

      it 'assigns the requested client to @clients' do
        @user.clients << @client
        get :show, id: @client
        expect(assigns(:client)).to eq(@client)
      end

      it 'renders the :show view' do
        @user.clients << @client
        get :show, id: @client
        expect(response).to render_template(:show)
      end

      it 'calculates correct total invoiced for client' do
        @user.clients << @client

        invoice1 = FactoryGirl.create(:invoice375)
        invoice2 = FactoryGirl.create(:invoice375)
        kreditnota = FactoryGirl.create(:kreditnota125)

        @client.invoices << invoice1
        @client.invoices << invoice2
        @client.invoices << kreditnota

        get :show, id: @client
        expect(assigns(:total_invoiced)).to eq(625.0)
      end

      it 'raises error if @user does not own requested client' do
        expect { get :show, id: @client }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :show, id: FactoryGirl.create(:client)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #new' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'assigns a new client to @client' do
        get :new
        expect(assigns(:client)).to be_a_new(Client)
      end

      it 'assigns @client to current user' do
        get :new
        expect(assigns(:client).user_id).to eq(@user.id)
      end

      it 'renders the :new view' do
        expect(get :new).to render_template(:new)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes (guest user)' do
      it 'does not save the client to the database' do
        expect do
          post :create, client: FactoryGirl.attributes_for(:client)
        end.to_not change(Client, :count)
      end
    end

    context 'with valid attributes (signed in)' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'saves the new client to the database' do
        expect do
          post :create, client: FactoryGirl.attributes_for(:client)
        end.to change(Client, :count).by(1)
      end

      it 'redirects to the :index view' do
        post :create, client: FactoryGirl.attributes_for(:client)
        expect(response).to redirect_to clients_path
      end
    end

    context 'with invalid attributes (signed in)' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      it 'does not save the new client to the database' do
        expect do
          post :create, client: FactoryGirl.attributes_for(:client, name: nil)
        end.to_not change(Client, :count)
      end

      it 're-renders the :new view' do
        post :create, client: FactoryGirl.attributes_for(:client, name: nil)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @client = FactoryGirl.create(:client)
      end

      context 'who owns client' do
        before :each do
          @user.clients << @client
        end

        it 'assigns requested client to @client' do
          get :edit, id: @client
          expect(assigns(:client)).to eq(@client)
        end

        it 'renders the :edit view' do
          expect(get :edit, id: @client).to render_template(:edit)
        end
      end

      context 'who does not own client' do
        it 'raises error' do
          expect { get :edit, id: @client }.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        get :edit, id: FactoryGirl.create(:client)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @client = FactoryGirl.create(:client, name: 'Even eier')
    end

    context 'when logged in' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
      end

      context 'and owner of client' do
        before :each do
          @user.clients << @client
        end

        context 'with valid attributes' do
          it 'locates the requested client' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client)
            expect(assigns(:client)).to eq(@client)
          end

          it 'changes clients attributes' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client, name: 'Edited', address: 'ny adresse')
            @client.reload
            expect(@client.name).to eq('Edited')
            expect(@client.address).to eq('ny adresse')
          end

          it 'redirects to :index view' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client)
            expect(response).to redirect_to(clients_path)
          end
        end

        context 'with invalid attributes' do
          it 'locates the requested client' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client, name: nil)
            expect(assigns(:client)).to eq(@client)
          end

          it 'does not change clients attributes' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client, name: nil, address: 'ny adresse')
            @client.reload
            expect(@client.name).to eq('Even eier')
            expect(@client.address).to_not eq('ny adresse')
          end

          it 're-renders the :edit view' do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client, name: nil)
            expect(response).to render_template(:edit)
          end
        end
      end

      context 'and not owner of client' do
        it 'raises record not found error' do
          expect do
            put :update, id: @client, client: FactoryGirl.attributes_for(:client)
          end.to raise_error(CanCan::AccessDenied)
        end
      end
    end

    context 'when guest' do
      it 'does not change client attributes' do
        put :update, id: @client, client: FactoryGirl.attributes_for(:client, name: 'hello', address: 'ny adresse')
        @client.reload
        expect(@client.name).to eq('Even eier')
        expect(@client.address).to_not eq('ny adresse')
      end

      it 'redirects to login' do
        put :update, id: @client, client: FactoryGirl.attributes_for(:client)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @user = FactoryGirl.create(:user)
      @client = FactoryGirl.create(:client)
    end

    context 'for signed in user' do
      before :each do
        sign_in @user
      end

      it 'raises error if user is not owner of client' do
        expect { delete :destroy, id: @client }.to raise_error(CanCan::AccessDenied)
      end

      it 'deletes the client' do
        @user.clients << @client
        expect { delete :destroy, id: @client }.to change(Client, :count).by(-1)
      end

      it 'redirects to clients#index after delete' do
        @user.clients << @client
        delete :destroy, id: @client
        expect(response).to redirect_to clients_path
      end
    end

    context 'for guest user' do
      it 'redirects to login' do
        delete :destroy, id: @client
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #get_json' do
    context 'for signed in user' do
      before :each do
        @user = FactoryGirl.create(:user)
        sign_in @user
        @client = FactoryGirl.create(:client, name: 'Even skaper ro')
      end

      it 'returns the correct client' do
        @user.clients << @client
        get :get_json, id: @client
        expect(response.body).to include('Even skaper ro')
      end

      it 'raises error if user is not owner of client' do
        expect { get :get_json, id: @client }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'for guest user' do
      it 'redirects to login page' do
        user = FactoryGirl.create(:user)
        client = FactoryGirl.create(:client)
        user.clients << client
        get :get_json, id: client
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
