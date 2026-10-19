class Admin::AnimalsController < ApplicationController
  before_action :require_login
  before_action :set_animal, only: [:edit, :update, :destroy]

  def index
    if current_user.admin?
      @animals = Animal.all
    else
      @animals = current_user.animals
    end
  end

  def new
    @animal = current_user.animals.build
  end

  def create
    @animal = current_user.animals.build(animal_params)
    if @animal.save
      redirect_to admin_animals_path, notice: "Animal cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @animal.update(animal_params)
      redirect_to admin_animals_path, notice: "Animal atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @animal.destroy
    redirect_to admin_animals_path, notice: "Animal removido com sucesso!"
  end

  private

  def set_animal
    if current_user.admin?
      @animal = Animal.find(params[:id])
    else
      @animal = current_user.animals.find(params[:id])
    end
  end

  def animal_params
    params.require(:animal).permit(
      :name, :species, :age, :sex, :size, :temperament,
      :health_status, :status, :description, :city, :state, photos: []
    )
  end
end
