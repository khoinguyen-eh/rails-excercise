class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :dob
      t.boolean :gender
      t.string :email
      t.string :password_digest
      t.bigint :tmp_author_id

      t.timestamps
    end

    password = BCrypt::Password.create('password')

    # Educational purposes only, set same password for all users
    command = <<-SQL
        INSERT INTO users (first_name, last_name, dob, gender, email, password_digest, tmp_author_id, created_at, updated_at)
        SELECT 
            first_name, 
            last_name, 
            dob, 
            gender,
            LOWER(first_name || '.' || last_name || '@example.com') AS email, 
            ?,
            id,
            created_at, 
            updated_at
        FROM authors
    SQL

    query = ActiveRecord::Base.send(:sanitize_sql_array, [command, password])
    execute query
  end

  def down
    drop_table :users
  end
end
