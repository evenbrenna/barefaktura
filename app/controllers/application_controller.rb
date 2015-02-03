class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # User authentication
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def authenticate_active_admin_user!
        authenticate_user!
        unless current_user.role?(:administrator)
            flash[:alert] = "Du har ikke tilgang til denne siden!"
            redirect_to root_path
        end
  end

  def after_sign_in_path_for(resource)
    @user = current_user
  end

  def configure_permitted_parameters
         devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,
                                                                  :password,
                                                                  :password_confirmation,
                                                                  :current_password,
                                                                  :name,
                                                                  :address,
                                                                  :phone,
                                                                  :org_number,
                                                                  :bank_name,
                                                                  :bank_account,
                                                                  :bank_swift,
                                                                  :bank_iban,
                                                                  :ref,
                                                                  :mva_reg,
                                                                  :foretaks_reg,
                                                                  :next_invoice_number)}

         devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email,
                                                                        :password,
                                                                        :password_confirmation,
                                                                        :current_password,
                                                                        :name,
                                                                        :address,
                                                                        :phone,
                                                                        :org_number,
                                                                        :bank_name,
                                                                        :bank_account,
                                                                        :bank_swift,
                                                                        :bank_iban,
                                                                        :ref,
                                                                        :mva_reg,
                                                                        :foretaks_reg,
                                                                        :next_invoice_number)}
  end
end
