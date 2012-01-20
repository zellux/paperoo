class CreateAuthorLines < ActiveRecord::Migration
  def change
    create_table :author_lines do |t|
      t.integer :author_id
      t.integer :article_id
      t.integer :position

      t.timestamps
    end
  end
end
