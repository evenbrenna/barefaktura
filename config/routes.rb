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

  # Could probably be more elegant
  get 'user_root' => 'invoices#index'

  ActiveAdmin.routes(self)
  get 'static_pages/home'

  # You can have the root of your site routed with "root"
  root 'static_pages#home'
end
