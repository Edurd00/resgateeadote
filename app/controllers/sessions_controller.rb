class SessionsController < ApplicationController
  def new
  end

  def create
    Rails.logger.info "=== DEBUG LOGIN PARAMS: #{request.filtered_parameters.inspect} ==="
    user = User.find_by(email: params[:email])
    Rails.logger.info "=== UTILIZADOR ENCONTRADO: #{user.present?} ==="

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Login realizado com sucesso!"
      redirect_to admin_animals_path
    else
      flash.now[:alert] = "Email ou password inválidos"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Logout realizado com sucesso!"
    redirect_to root_path
  end
end
