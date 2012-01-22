class AddCommentsCountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :comments_count, :integer, :default => 0
    Article.reset_column_information
    Article.find(:all).each do |a|
      a.comments_count = a.comments.count
      a.save
    end
  end
end
