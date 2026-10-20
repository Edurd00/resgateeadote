require "digest/md5"

class Admin::AnimalsController < ApplicationController
  before_action :require_login
  before_action :set_animal, only: [:edit, :update, :destroy, :purge_photo]

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
    animal_params_without_photos = animal_params.except(:photos)

    if @animal.update(animal_params_without_photos)
      new_photos = animal_params[:photos]
      if new_photos.present? && new_photos.any?(&:present?)
        new_photos.each do |new_photo|
          next unless new_photo.present?

          checksum = Digest::MD5.file(new_photo.tempfile.path).base64digest
          already_attached = @animal.photos.attachments.any? { |photo| photo.blob.checksum == checksum }
          @animal.photos.attach(new_photo) unless already_attached
        end
      end

      redirect_to admin_animals_path, notice: "Animal atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @animal.destroy
    redirect_to admin_animals_path, notice: "Animal removido com sucesso!"
  end

  def purge_photo
    photo = @animal.photos.attachments.find_by(id: params[:photo_id])
    photo&.purge

    redirect_to edit_admin_animal_path(@animal), notice: "Foto removida com sucesso."
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
