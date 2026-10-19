class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Login realizado com sucesso!"
      redirect_to admin_animals_path
    else
      flash.now[:alert] = "E-mail ou senha inválidos."
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Logout realizado com sucesso!"
    redirect_to root_path
  end
end
