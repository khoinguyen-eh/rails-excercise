class RemoveAuthorIdFromBook < ActiveRecord::Migration[7.0]
  def up
    remove_reference :books, :author, null: false, foreign_key: true
  end

  def down
    add_reference :books, :author, null: false, foreign_key: true

    # This is a bad idea, but it's the only way to revert the migration (at least for educational purposes)
    execute <<-SQL
      UPDATE books
      SET author_id = (
        SELECT author_id
        FROM authors_books
        WHERE book_id = books.id
        LIMIT 1
      )
    SQL
  end
end
