class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.integer :account_id
      t.references :commentable, :polymorphic => true

      t.timestamps
    end
    add_index :comments, :commentable_id
  end
end
