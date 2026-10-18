class User < ApplicationRecord
  has_secure_password

  enum role: { rescuer: 0, admin: 1 }

  has_many :animals, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
