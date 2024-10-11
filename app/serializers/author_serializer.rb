class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :pen_name, :bio, :is_verified

  has_many :books
end