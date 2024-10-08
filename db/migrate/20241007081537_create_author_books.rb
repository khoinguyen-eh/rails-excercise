class CreateAuthorBooks < ActiveRecord::Migration[7.0]
  def up
    create_table :author_books do |t|
      t.references :author, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end

    add_index :author_books, [:author_id, :book_id], unique: true

    Book.all.each do |book|
      AuthorBook.create(author_id: book.author_id, book_id: book.id)
    end

    remove_column :books, :author_id, :bigint
  end

  def down
    add_column :books, :author_id, :bigint

    # This is a bad idea, but it's the only way to revert the migration
    AuthorBook.all.each do |author_book|
      book = Book.find(author_book.book_id)
      book.update(author_id: author_book.author_id)
    end

    drop_table :author_books
  end
end
