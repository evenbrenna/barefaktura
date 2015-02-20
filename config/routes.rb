Rails.application.routes.draw do

  get 'static_pages/help'
  get 'static_pages/home'

  resources :products, :clients
  devise_for :users, :path_prefix => 'auth'
  resources :users, only: [:show]

  resources :invoices, except: [:edit, :update, :destroy] do
    get :set_paid, on: :member
  end

  match :send_email_invoice, to: 'invoices#send_email_invoice', via: 'post'
  get :email_invoice, to: 'invoices#email_invoice', as: :email_invoice

  get :kreditnota, to: 'invoices#kreditnota', as: :kreditnota

  # get client info as json
  get "clients/:id/client_json", :controller=>"clients", :action=>"client_json"

  # get product info as json
  get "products/:id/product_json", :controller=>"products", :action=>"product_json"

  get 'invoice_items/destroy'

  # Could probably be more elegant
  get 'user_root' => 'users#show'

  ActiveAdmin.routes(self)
  get 'static_pages/home'

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

end
