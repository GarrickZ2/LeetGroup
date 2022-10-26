class UserController < ApplicationController
    def index
        @login_type = params[:type]
        if @login_type == nil || @login_type == ''
            @login_type = 'login'
        end
    end

    def create
        unless check_email_format params[:email]
            flash[:r_notice] = "Email Format is not correct"
            redirect_to user_index_path type: 'register'
            return
        end
        unless check_password_strong params[:password]
            flash[:r_notice] = "Password has to contains at least 1 Uppercase, Lowercase letter, 1 digit and 1 special character, and length larger than 8"
            redirect_to user_index_path type: 'register'
            return
        end
        unless check_username_format params[:username]
            flash[:r_notice] = "Username can only contains letter and digits, length between 6 to 50"
            redirect_to user_index_path type: 'register'
            return
        end
        uid = create_user params[:username], params[:email], params[:password]
        if uid == -1
            flash[:r_notice] = "Username has been taken, please use another one"
            redirect_to user_index_path type: 'register'
            return
        end
        if uid == -2
            flash[:r_notice] = "Email is in used, please use another one"
            redirect_to user_index_path type: 'register'
            return
        end
        session[:uid] = uid
        redirect_to main_dashboard_path
    end

    def check_email_format(email)
        true
    end

    def check_password_strong(password)
        false
    end

    def check_username_format(username)
        true
    end

    def create_user(username, email, password)
        20
    end

end
