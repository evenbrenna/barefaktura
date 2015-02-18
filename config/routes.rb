Rails.application.routes.draw do

  get 'static_pages/help'
  get 'static_pages/home'

  resources :products

  get :kreditnota, to: 'invoices#kreditnota', as: :kreditnota

  # get client info as json
  get "clients/:id/client_json", :controller=>"clients", :action=>"client_json"

  # get product info as json
  get "products/:id/product_json", :controller=>"products", :action=>"product_json"

  resources :invoices, except: [:edit, :update, :destroy] do
    get :set_paid, on: :member
  end

  get 'invoice_items/destroy'
  get :email_invoice, to: 'invoices#email_invoice', as: :email_invoice
  match :send_email_invoice, to: 'invoices#send_email_invoice', via: 'post'

  resources :clients

  devise_for :users, :path_prefix => 'auth'
  resources :users, only: [:show]

  ActiveAdmin.routes(self)
  get 'static_pages/home'


  # You can have the root of your site routed with "root"
  root 'static_pages#home'

end
