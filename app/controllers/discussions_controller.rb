class ChallengesController < ApplicationController
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
