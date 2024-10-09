class CreateJoinTableAuthorBook < ActiveRecord::Migration[7.0]
  def up
    create_join_table :authors, :books do |t|
      t.index [:author_id, :book_id]
    end

    execute <<-SQL
      INSERT INTO authors_books (author_id, book_id)
      SELECT author_id, id
      FROM books
    SQL
  end

  def down
    drop_table :authors_books
  end
end
