class CreateBooks < ActiveRecord::Migration[7.0]
  def up
    create_table :books do |t|
      t.string :isbn
      t.string :name
      t.references :author, null: false, foreign_key: true
      t.date :publish_date
      t.string :genre, array: true, default: []
      t.decimal :rating
      t.text :desc

      t.timestamps
    end
  end

  def down
    drop_table :books
  end
end
