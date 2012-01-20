class AddPagesToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :page_start, :integer
    add_column :articles, :page_end, :integer
  end
end
