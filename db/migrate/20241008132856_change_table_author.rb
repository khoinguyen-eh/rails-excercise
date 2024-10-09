class ChangeTableAuthor < ActiveRecord::Migration[7.0]
  def up
    change_table :authors do |t|
      t.remove :first_name, :last_name, :dob, :gender

      t.string :pen_name
      t.text :bio
      t.boolean :is_verified
      t.references :user, index: true, foreign_key: true
    end

    execute <<-SQL
      UPDATE authors
      SET user_id = users.id
      FROM users
      WHERE authors.id = users.tmp_author_id
    SQL
  end

  def down
    change_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.boolean :gender

      t.remove :pen_name
      t.remove :bio
      t.remove :is_verified, default: false
    end

    execute <<-SQL
      UPDATE authors
      SET first_name = users.first_name,
          last_name = users.last_name,
          dob = users.dob,
          gender = users.gender
      FROM users
      WHERE authors.user_id = users.id
    SQL

    remove_reference :authors, :user, index: true, foreign_key: true
  end
end
