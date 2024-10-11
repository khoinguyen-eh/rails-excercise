class BookSerializer < ActiveModel::Serializer
  attributes :id, :isbn, :name, :publish_date, :genre, :rating, :desc

  has_many :authors do
    include_authors = scope ? scope[:include_authors] : nil
    if include_authors == 'id_only'
      object.authors.select(:id, :user_id).map do |author|
        {
          id: author.id,
          user_id: author.user_id
        }
      end
    elsif include_authors == 'id_and_name'
      object.authors.all.map do |author|
        {
          id: author.id,
          user_id: author.user_id,
          first_name: author.user.first_name,
          last_name: author.user.last_name
        }
      end
    elsif include_authors == 'all'
      object.authors.all.map do |author|
        {
          id: author.id,
          pen_name: author.pen_name,
          bio: author.bio,
          is_verified: author.is_verified,
          user: author.user
        }
      end
    else
      nil
    end
  end
end