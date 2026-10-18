class Animal < ApplicationRecord
  has_many_attached :photos

  validate :acceptable_photos

  private

  ACCEPTABLE_CONTENT_TYPES = ["image/png", "image/jpg", "image/jpeg", "image/webp"].freeze
  MAX_FILE_SIZE = 5.megabytes

  def acceptable_photos
    return unless photos.attached?

    photos.each do |photo|
      unless photo.blob.byte_size <= MAX_FILE_SIZE
        errors.add(:photos, "deve ter no máximo 5MB por foto")
      end

      unless ACCEPTABLE_CONTENT_TYPES.include?(photo.blob.content_type)
        errors.add(:photos, "deve ser do formato PNG, JPG, JPEG ou WEBP")
      end
    end
  end
end
