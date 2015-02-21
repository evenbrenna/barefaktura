require 'rails_helper'

describe UsersController do
  describe 'GET #show' do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it 'assigns the requested user to @user' do
      get :show, id: @user
      expect(assigns(:user)).to eq(@user)
    end

    it 'assigns only unpaid invoices to @invoices' do
      unpaid = FactoryGirl.create(:invoice, paid: false)
      paid = FactoryGirl.create(:invoice, paid: true)
      kreditnota = FactoryGirl.create(:invoice, kreditnota: true, paid: true)

      @user.invoices << unpaid
      @user.invoices << paid
      @user.invoices << kreditnota

      get :show, id: @user
      expect(assigns(:invoices).count).to eq(1)
    end

    it 'renders the :show view' do
      get :show, id: @user
      expect(response).to render_template :show
    end
  end
end
