require 'test_helper'

class UserTest < ActiveSupport::TestCase

    test "should not save user without email" do
        user = User.new
        user.display_name = "qwerty"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert !user.save, "Saved the user without a email"
    end

    test "should not save user without display name" do
        user = User.new
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert !user.save, "Saved the user without a display name"
    end

    test "should not save user without password confirmation" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        assert !user.save, "Saved the user without a password confirmation"
    end

    test "should not save user where password and password confirmation are different" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        user.password_confirmation = "ytrewq"
        assert !user.save, "Saved the user without passwor_confirmation matching"
    end

    test "valid case" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert user.save
        assert_equal(user.logged_in, false)
    end

    test "should not save user with duplicate email" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert user.save
        # do it again with same email
        user = User.new
        user.display_name = "ytrewq"
        user.email = "qwerty@example.com"
        user.password = "ytrewq"
        user.password_confirmation = "ytrewq"
        assert !user.save, "Saved user with duplicate email"
    end

    test "should not save with a invalid email address" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert !user.save, "Saved user with invalid email"
    end

    test "email should be converted to lowercase when saved" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "QweRtY@EXAmplE.CoM"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert user.save
        assert_equal(user.email, "qwerty@example.com")
    end

    test "saved user should have a remember token created" do
        user = User.new
        user.display_name = "qwerty"
        user.email = "qwerty@example.com"
        user.password = "qwerty"
        user.password_confirmation = "qwerty"
        assert user.save
        assert_not_nil(user.remember_token)
    end
end
