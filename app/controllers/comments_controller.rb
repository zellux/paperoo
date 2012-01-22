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


  def update
    @comment = Comment.find(params[:id])
    if @comment.account_id != current_account.id
      flash[:error] = "You cannot modify other's comment"
    else
      flash[:notice] = "Comment modified successfully"
      @comment.text = params[:text]
      if !@comment.save
        logger.error @comment.errors.full_messages
      end
    end
    redirect_to request.referer || article_index_path
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.account_id != current_account.id
      flash[:error] = "You cannot delete other's comment"
    else
      @comment.destroy
      flash[:notice] = "Comment deleted successfully"
    end
    redirect_to request.referer || article_index_path
  end
end

