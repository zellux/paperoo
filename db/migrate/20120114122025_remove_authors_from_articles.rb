class RemoveAuthorsFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :authors
  end

  def down
    add_column :articles, :authors, :text
  end
end
