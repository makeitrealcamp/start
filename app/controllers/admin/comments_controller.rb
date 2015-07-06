class Admin::CommentsController < ApplicationController
   before_action :admin_access

  def index
    @comments = Comment.all.limit(100)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end
end
