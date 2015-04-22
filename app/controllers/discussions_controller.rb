class DiscussionsController < ApplicationController
  before_action :private_access

  # GET /discussion/:id/comments
  def comments
    discussion = Discussion.find(params[:id])
    comments = discussion.comments.order("created_at DESC")
    render json: comments.to_json
  end

  # POST /discussion/:id/comments
  def create_comment
    discussion = Discussion.find(params[:id])
    comment = Comment.new(create_comment_params.merge(
      discussion: discussion, user: current_user
    ))
    if comment.save
      render json: comment.to_json
    else
      render json: {errors: comment.errors }, status: :bad_request
    end
  end

  protected
  def create_comment_params
    params.permit(:text,:response_to_id)
  end
end
