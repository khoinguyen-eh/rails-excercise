class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :dob, :gender, :email
end
