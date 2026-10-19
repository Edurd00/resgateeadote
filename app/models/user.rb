class User < ApplicationRecord
  has_secure_password

  enum role: { admin: 0, superadmin: 1 }

  has_many :animals, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
