# == Schema Information
#
# Table name: conferences
#
#  id             :integer(4)      not null, primary key
#  title          :string(255)
#  year           :integer(4)
#  booktitle      :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  articles_count :integer(4)      default(0)
#  pageview       :integer(4)      default(0)
#

class Conference < ActiveRecord::Base
  paginates_per 20

  has_many :articles
end
