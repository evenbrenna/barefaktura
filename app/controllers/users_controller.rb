# Actions related to Users that are not handled by Devise.
class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    # Unpaid invoices
    @invoices = current_user.invoices.unpaid
  end
end
