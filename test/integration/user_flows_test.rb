require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
    fixtures :users
 
    test "login and change status" do
        str_status = "Out to lunch."

        get "/signin"
        assert_response :success

        post_via_redirect "/sessions", :session => { :email => users(:john).email,
                                                     :password => "foobar" }
        # redirected to users page
        assert_equal '/users', path
        assert_response :success
        assert assigns(:users)
        # check that the john users logged_in flag was set
        user = User.find(users(:john).id)
        assert user.logged_in
        # make sure we are changing the status
        assert_not_equal(str_status, user.status)
        # go to johns edit page
        get edit_user_path(users(:john))
        assert_response :success
        assert assigns(:user)
        # change his status
        put_via_redirect user_path(users(:john)), :user => { :display_name => users(:john).display_name,
                                                             :status => str_status }
        assert_equal user_path(users(:john)), path                                              
        user = User.find(users(:john).id)
        assert_equal(str_status, user.status)
    end

    test "should not be able to change other peoples status" do
        # log in
        post_via_redirect "/sessions", :session => { :email => users(:john).email,
                                                     :password => "foobar" }
        # go to someone elses edit page
        get_via_redirect edit_user_path(users(:sam))
        # make sure we got redirected to root
        assert_equal root_path, path
        # try to change someone elses user page
        put_via_redirect user_path(users(:sam)), :user => { :display_name => users(:john).display_name,
                                                             :status => users(:john).status }
        # make sure we got redirected to root
        assert_equal root_path, path
        #make sure sams stuff didnt get changed
        sam_user = User.find(users(:sam))
        assert_not_equal(sam_user.display_name, users(:john).display_name)
        assert_not_equal(sam_user.status, users(:john).status)
    end

    test "after logging out you should be able to access the users page" do
        post_via_redirect "/sessions", :session => { :email => users(:john).email,
                                                     :password => "foobar" }
        # access users page
        assert_equal '/users', path
        assert_response :success
        assert assigns(:users)
        # signout
        delete_via_redirect "/signout", :session => { }
        # signed out, should go to root path
        assert_equal root_path, path
        assert_response :success
        # now go back to users page
        get_via_redirect "/users"
        # and make sure we got redirected to the signin page
        assert_equal '/signin', path
    end
end
