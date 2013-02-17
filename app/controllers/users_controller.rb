class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        @user = User.new(:display_name => params[:user][:display_name],
                         :email => params[:user][:email],
                         :password => params[:user][:password],
                         :password_confirmation => params[:user][:password_confirmation])
        if @user.save
            # sign_in @user
            flash[:success] = "Account created. Welcome to the Clio Status Board!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def index
        @users = User.all
    end
end
