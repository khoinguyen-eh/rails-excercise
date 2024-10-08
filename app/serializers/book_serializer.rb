class BookSerializer < ActiveModel::Serializer
  attributes :id, :isbn, :name, :publish_date, :genre, :rating, :desc

  has_many :authors do
    include_authors = scope ? scope[:include_authors] : nil
    if include_authors == 'id_only'
      object.authors.select(:id).map do |author|
        {
          id: author.id
        }
      end
    elsif include_authors == 'id_and_name'
      object.authors.select(:id, :first_name, :last_name).map do |author|
        {
          id: author.id,
          first_name: author.first_name,
          last_name: author.last_name
        }
      end
    elsif include_authors == 'all'
      object.authors
    else
      nil
    end
  end
end