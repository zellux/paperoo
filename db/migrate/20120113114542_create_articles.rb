class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :abstract
      t.integer :conference_id
      t.integer :year

      t.timestamps
    end
  end
end
