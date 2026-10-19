class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].presence || params.dig(:session, :email)
    password = params[:password].presence || params.dig(:session, :password)
    user = User.find_by(email: email)

    if user.nil? && email.present? && password.present?
      bootstrap_email = ENV.fetch("SUPERADMIN_EMAIL", "admin@resgateeadote.com.br")
      bootstrap_password = ENV["SUPERADMIN_PASSWORD"]

      if bootstrap_password.present? && email.casecmp?(bootstrap_email) &&
          ActiveSupport::SecurityUtils.secure_compare(password, bootstrap_password)
        user = User.create!(
          name: "Administrador",
          email: bootstrap_email,
          password: bootstrap_password,
          password_confirmation: bootstrap_password,
          role: :superadmin,
          phone: "000000000"
        )
      end
    end

    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to admin_animals_path, notice: "Bem-vindo ao painel!"
    else
      flash.now[:alert] = "E-mail ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Logout realizado com sucesso!"
    redirect_to root_path
  end
end
