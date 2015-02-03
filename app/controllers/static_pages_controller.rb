class StaticPagesController < ApplicationController
    def home
        @user = current_user
    end

    def help
        @user = current_user
    end
end
