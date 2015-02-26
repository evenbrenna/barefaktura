require 'rails_helper'

describe StaticPagesController do
  describe 'GET #home' do
    it 'renders the :home view for signed in user' do
      user = FactoryGirl.create(:user)
      sign_in user
      get :home, :id => user
      expect(response).to render_template :home
    end

    it 'renders the :home view for guest user' do
      get :home, :id => nil
      expect(response).to render_template :home
    end
  end

  describe 'GET #help' do
    it 'renders the :help view for signed in user' do
      user = FactoryGirl.create(:user)
      sign_in user
      get :help, :id => user
      expect(response).to render_template :help
    end

    it 'renders the :help view for guest user' do
      get :help, :id => nil
      expect(response).to render_template :help
    end
  end
end
