class RemoveAuthorIdFromBook < ActiveRecord::Migration[7.0]
  def up
    remove_reference :books, :author, null: false, foreign_key: true
  end

  def down
    add_reference :books, :author, null: false, foreign_key: true

    # This is a bad idea, but it's the only way to revert the migration (at least for educational purposes)
    Book.all.each do |book|
      author_book = book.authors.first
      book.update(author_id: author_book.author_id) if author_book
    end
  end
end
