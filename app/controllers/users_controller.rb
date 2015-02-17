class UsersController < ApplicationController

    before_filter :authenticate_user!
    load_and_authorize_resource

    def show
        @user = current_user
        @invoices = current_user.invoices.except(:order).order(
            'invoice_number DESC').select{ |i| !i.paid && !i.kreditnota } #Outstanding
    end
end
