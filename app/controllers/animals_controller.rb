class AnimalsController < ApplicationController
  def index
    @animals = Animal.published
    if params[:species].present? && Animal.species.key?(params[:species])
      @animals = @animals.where(species: params[:species])
    end
  end

  def show
    @animal = Animal.published.find(params[:id])
  end
end
