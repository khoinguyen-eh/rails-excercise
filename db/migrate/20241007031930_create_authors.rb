class CreateAuthors < ActiveRecord::Migration[7.0]
  def up
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.boolean :gender

      t.timestamps
    end
  end

  def down
    drop_table :authors
  end
end
