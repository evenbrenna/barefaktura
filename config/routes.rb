Rails.application.routes.draw do
  get 'static_pages/help'
  get 'static_pages/home'

  resources :products do
    get :product_json, :on => :member
  end

  resources :clients do
    get :client_json, :on => :member
  end

  devise_for :users, :path_prefix => 'auth'
  resources :users, :only => [:show]

  resources :invoices, :except => [:edit, :update, :destroy] do
    get :set_paid,            :on => :member
    get :kreditnota,          :on => :member
    get :email_invoice,       :on => :member
    post :send_email_invoice, :on => :member
  end

  get 'invoice_items/destroy'


  ActiveAdmin.routes(self)
  get 'static_pages/home'

  # Set different roots for guest and logged in user
  authenticated :user do
    root 'invoices#index', :as => 'auth_root'
  end
  root 'static_pages#home'
end
