class Admin::UsersController < ApplicationController
  before_action :require_login
  before_action :require_superadmin

  def index
    @users = User.order(:email)
  end

  def new
    @user = User.new(role: :admin)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "Voluntário cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_superadmin
    return if current_user&.superadmin?

    redirect_to admin_animals_path, alert: "Acesso negado"
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end
end
