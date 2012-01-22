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

  after_create :increase_article_comments_count
  before_destroy :decrease_article_comments_count

  protected

  def increase_article_comments_count
    if self.commentable_type.downcase == 'article'
      Article.update_counters self.commentable_id, :comments_count => 1
    end
  end

  def decrease_article_comments_count
    logger.debug 'before destory'
    logger.debug self.to_json
    if self.commentable_type.downcase == 'article'
      Article.update_counters self.commentable_id, :comments_count => -1
    end
  end
end
