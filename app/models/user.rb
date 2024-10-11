class User < ApplicationRecord
  has_secure_password
  has_one :author, dependent: :destroy, inverse_of: :user

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :dob, presence: true
  validates :gender, presence: true
  validates :password, presence: true, length: { minimum: 8 }
end
