class CommentsController < ApplicationController
  before_filter :authenticate_account!

  def create
    comment = Comment.create(
                      :account_id => current_account.id,
                      :commentable_id => params[:commentable_id],
                      :commentable_type => params[:commentable_type],
                      :text => params[:text])
    redirect_to request.referer || article_index_path
  end
end

