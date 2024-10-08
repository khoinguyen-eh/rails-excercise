class CreateJoinTableAuthorBook < ActiveRecord::Migration[7.0]
  def up
    create_join_table :authors, :books do |t|
      t.index [:author_id, :book_id]
    end

    Book.all.each do |book|
      author = Author.find(book.author_id)
      book.authors << author if author
    end
  end

  def down
    drop_table :author_books
  end
end
