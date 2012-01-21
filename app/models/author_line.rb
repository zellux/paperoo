# == Schema Information
#
# Table name: author_lines
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  article_id :integer(4)
#  position   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class AuthorLine < ActiveRecord::Base
  belongs_to :author, :counter_cache => :articles_count
  belongs_to :article

  validates :author, :article, :position, :presence => true
end
