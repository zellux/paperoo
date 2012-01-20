class AddPageView < ActiveRecord::Migration
  def change
    add_column :authors, :pageview, :integer, :default => 0
    add_column :conferences, :pageview, :integer, :default => 0
    add_column :articles, :pageview, :integer, :default => 0
  end
end
