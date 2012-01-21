class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :likeable, :polymorphic => true
      t.integer :account_id

      t.timestamps
    end
    add_index :likes, :likeable_id
  end
end
