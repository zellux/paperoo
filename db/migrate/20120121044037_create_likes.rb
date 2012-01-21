class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :likeable
      t.integer :user_id

      t.timestamps
    end
    add_index :likes, :likeable_id
  end
end
