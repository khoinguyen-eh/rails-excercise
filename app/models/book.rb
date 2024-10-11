class Book < ApplicationRecord
  has_and_belongs_to_many :authors, inverse_of: :books

  validates :isbn, presence: true, uniqueness: true
  validates :name, presence: true
  validates :publish_date, presence: true
  validates :genre, presence: true
  validates :rating, presence: true
  validates :desc, presence: true
end
