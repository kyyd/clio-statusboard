require 'test_helper'

class UsersControllerTest < ActionController::TestCase
    test "should get new" do
        get :new
        assert_response :success
    end

    test "should create user" do
        assert_difference('User.count') do
            post :create, :user => { :display_name => 'Mickey Mouse',
                                     :email => "mickey@disney.com",
                                     :password => "minnie",
                                     :password_confirmation => "minnie"}
        end
        assert_redirected_to user_path(assigns(:user))
    end

    test "should not be able to get index when not logged in" do
        get :index
        assert_redirected_to("/signin")
    end

    test "should not be able to access users profile page" do
        get(:show, {'id' => users(:sam).id})
        assert_redirected_to("/signin")
    end

    test "should not be able to access users edit page" do
        get(:edit, {'id' => users(:sam).id})
        assert_redirected_to("/signin")
    end

end
