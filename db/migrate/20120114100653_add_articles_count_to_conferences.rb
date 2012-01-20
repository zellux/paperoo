class AddArticlesCountToConferences < ActiveRecord::Migration
  def up
    add_column :conferences, :articles_count, :integer, :default => 0
    say 'Calculating articles_count for existing conferences'
    Conference.reset_column_information
    Conference.find(:all).each do |c|
      Conference.reset_counters c.id, :articles
      say "#{c.title} #{c.articles_count}"
    end
  end

  def down
    remove_column :conferences, :articles_count
  end
end
