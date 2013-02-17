module SessionsHelper
    def sign_in(user)
        cookies.permanent[:remember_token] = user.remember_token
        # set user logged in
        self.current_user = user
    end
end
