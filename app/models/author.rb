# == Schema Information
#
# Table name: authors
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  institute      :string(255)
#  articles_count :integer(4)      default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  pageview       :integer(4)      default(0)
#

class Author < ActiveRecord::Base
  scope :with_article, where('articles_count > 0')
  paginates_per 20

  has_many :author_lines
  has_many :articles, :through => :author_lines
end
