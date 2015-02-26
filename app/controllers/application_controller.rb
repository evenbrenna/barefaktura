# All controllers inherit from this class
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception..
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  # Check permitted parameters if controller uses Devise (User)
  before_action :configure_permitted_parameters, :if => :devise_controller?

  # Active Admin uses this to check if user can access back end
  def authenticate_active_admin_user!
    authenticate_user!
    return if current_user.role? :administrator
    flash[:alert] = 'Du har ikke tilgang til denne siden!'
    redirect_to root_path
  end

  private

  # Strong parameters for sign up and account update via Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(sanitized_params)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(sanitized_params)
    end
  end

  # Helper method for configure_permitted_parameters
  def sanitized_params
    [:email, :password, :password_confirmation, :current_password,
     :name, :address, :phone, :org_number, :bank_name, :bank_account,
     :bank_swift, :bank_iban, :ref, :mva_reg, :foretaks_reg,
     :next_invoice_number]
  end
end
