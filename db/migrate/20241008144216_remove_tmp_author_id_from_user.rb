class RemoveTmpAuthorIdFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :tmp_author_id, :bigint
  end
end
