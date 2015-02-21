# Each action relates to a static page.
class StaticPagesController < ApplicationController
  def home
    @user = current_user
    render :layout => 'landing'
  end

  def help
    @user = current_user
  end
end
