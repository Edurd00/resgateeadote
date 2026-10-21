class AnimalsController < ApplicationController
  def index
    @animals = Animal.published
    if params[:species].present? && Animal.species.key?(params[:species])
      @animals = @animals.where(species: params[:species])
    end
    if params[:size].present? && Animal.sizes.key?(params[:size])
      @animals = @animals.where(size: params[:size])
    end
    sex = params[:gender].presence || params[:sex]
    if sex.present? && Animal.sexes.key?(sex)
      @animals = @animals.where(sex: sex)
    end
  end

  def show
    @animal = Animal.published.find(params[:id])
  end
end
