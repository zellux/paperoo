# == Schema Information
#
# Table name: likes
#
#  id          :integer(4)      not null, primary key
#  likeable_id :integer(4)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Like < ActiveRecord::Base
  belongs_to :likeable
end
