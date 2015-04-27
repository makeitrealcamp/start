class Admin::CommentsController < ApplicationController

  def index
    @comments = Comment.order("created_at DESC").limit(100)
  end
end
