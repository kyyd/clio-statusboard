class UsersController < ApplicationController
    before_filter :signed_in_user, only: [:index, :edit, :update, :show]
    before_filter :correct_user,   only: [:edit, :update]

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

    def edit
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        # we are only updating display_name and status,
        # and the only thing we need to validate is display name is not empty
        if params[:user][:display_name] != ""
            @user.update_column(:display_name, params[:user][:display_name])
            @user.update_column(:status, params[:user][:status])
            flash[:success] = "Account updated"
            sign_in @user
            redirect_to @user
        else
            flash[:error] = "Disply name cannot be empty"
            render 'edit'
        end
    end

    private
        def signed_in_user
            unless signed_in?
                store_location
                redirect_to signin_url, notice: "Please sign in."
            end
        end
        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_path) unless current_user?(@user)
        end
end
