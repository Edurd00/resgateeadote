class Animal < ApplicationRecord
  belongs_to :user, optional: true

  has_many_attached :photos, dependent: :destroy

  enum species: { cat: 0, dog: 1 }
  enum sex: { male: 0, female: 1 }
  enum size: { small: 0, medium: 1, large: 2 }
  enum status: { available: 0, in_process: 1, adopted: 2 }

  scope :published, -> { available }

  def cover_photo
    photos.attachments.find do |attachment|
      ActiveModel::Type::Boolean.new.cast(attachment.blob.custom_metadata["cover"])
    end || photos.first
  end

  validate :acceptable_photos

  private

  ACCEPTABLE_CONTENT_TYPES = ["image/png", "image/jpg", "image/jpeg", "image/webp"].freeze
  MAX_FILE_SIZE = 5.megabytes

  def acceptable_photos
    if photos.attachments.size > 3
      errors.add(:photos, "permite no máximo 3 fotos por pet")
    end

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
