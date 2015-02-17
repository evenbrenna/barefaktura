class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    @user = current_user
    # Unpaid invoices
    @invoices = current_user.invoices.except(:order).order(
      'invoice_number DESC').select { |i| !i.paid && !i.kreditnota }
  end
end
