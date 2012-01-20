class Author < ActiveRecord::Base
  scope :with_article, where('articles_count > 0')
  paginates_per 20

  has_many :author_lines
  has_many :articles, :through => :author_lines
end
