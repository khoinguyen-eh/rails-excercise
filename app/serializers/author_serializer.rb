class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :dob, :gender

  has_many :books
end