# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  text             :text
#  account_id       :integer(4)
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :account

  validates :account_id, :commentable_id, :commentable_type, :text, :presence => true
end
