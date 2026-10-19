class Admin::ProfilesController < ApplicationController
  before_action :require_login

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    attributes = profile_params.to_h

    if attributes["password"].blank?
      attributes.delete("password")
      attributes.delete("password_confirmation")
    end

    if @user.update(attributes)
      redirect_to edit_admin_profile_path, notice: "Seus dados foram atualizados com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
