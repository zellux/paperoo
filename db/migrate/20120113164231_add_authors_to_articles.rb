class AddAuthorsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :authors, :text
  end
end
