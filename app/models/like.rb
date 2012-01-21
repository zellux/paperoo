# == Schema Information
#
# Table name: likes
#
#  id            :integer(4)      not null, primary key
#  likeable_id   :integer(4)
#  likeable_type :string(255)
#  account_id    :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#

class Like < ActiveRecord::Base
  belongs_to :likeable, :polymorphic => true
  validate :likeable_id, :likeable_type, :account_id, :presence => true

  def self.for(object, account)
    scoped.where(:likeable_id => object.id, :likeable_type => object.class.to_s, :account_id => account.id)
  end
end
