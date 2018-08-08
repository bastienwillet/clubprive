class UsersController < ApplicationController
    def new
    end

    def create
        if params[:user][:password] == params[:user][:password_confirmation]
            user = User.create(first_name: params[:user][:first_name], last_name: params[:user][:last_name], email: params[:user][:email], password: params[:user][:password])
            if user.new_record? == false
                log_in user
                params[:user][:remember_me] == '1' ? remember(user) : forget(user)
                flash[:success] = 'Utilisateur créé'
                redirect_to '/'
            else
                flash[:danger] = 'Ya un problème mon coco'
            end
        else
            flash[:danger] = 'Mots de passe différents :/'
        end
    end

    def show
        @user = User.find(params[:id])
        if logged_in? == false
            flash[:danger] = 'hey login-toi pour y accéder'
            redirect_to '/login'
        end
    end

    def edit
        @user = User.find(params[:id])
        if logged_in? == false
            flash[:danger] = 'Touche pas à ça coquin'
            redirect_to '/login'
        elsif current_user.id != @user.id
            flash[:danger] = 'Touche pas à ça coquin'
            redirect_to '/'
        end
    end

    def update
        @user = User.find(params[:id])
        if params[:user][:password] == params[:user][:password_confirmation]
            user_params = params.require(:user).permit(:first_name, :last_name, :email, :password)
            if @user.update_attributes(user_params)
                flash[:success] = 'Compte modifié'
                redirect_to '/'
            else
                flash[:danger] = 'Ya un problème mon coco'
            end
        else
            flash[:danger] = 'Mots de passe différents :/'
        end
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = 'Compte supprimé'
        redirect_to '/'
    end

    def index
        if logged_in? == false
            flash[:danger] = 'hey login-toi pour y accéder'
            redirect_to '/login'
        else
            @users = User.all
        end
    end
end
