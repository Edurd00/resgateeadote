class User < ApplicationRecord
  has_secure_password

  enum role: { admin: 0, superadmin: 1 }

  has_many :animals, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  before_validation :normalize_phone
  validates :phone, format: { with: /\A(?:\d{10,11}|55\d{10,11})\z/, message: "deve incluir o DDD e conter um número válido" }, allow_blank: true

  private

  def normalize_phone
    self.phone = phone.to_s.gsub(/\D/, "") if phone.present?
  end
end
