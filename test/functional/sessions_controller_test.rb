require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
    test "should get new" do
        get :new
        assert_response :success
    end

    test "creating sessions should assign cookie" do
        assert_nil(cookies[:remember_token])
        post :create, :session => { :email => 'john.doe@example.com',
                                    :password => "foobar"}
        assert_not_nil(cookies[:remember_token])
        assert_redirected_to users_path
    end

    test "incorrect password should not create cookie" do
        post :create, :session => { :email => 'john.doe@example.com',
                                    :password => "not_the_password"}
        assert_nil(cookies[:remember_token])
        # no redirect, just back to same page
        assert_response :success
    end

    test "should destroy cookie" do
        cookies[:remember_token] = "Something not null"
        delete :destroy, :session => { }
        assert_nil(cookies[:remember_token])
        assert_redirected_to root_path
    end
end
