# Each action relates to a static page.
class StaticPagesController < ApplicationController
  def home
    render :layout => 'landing'
  end

  def help
  end
end
