class AuthorLine < ActiveRecord::Base
  belongs_to :author, :counter_cache => :articles_count
  belongs_to :article

  validates :author, :article, :position, :presence => true
end
