class CommentsController < ApplicationController
  before_action :private_access
  before_action :set_instance, only: [:index, :create]

  # POST /:commentable_resource/:id/comments
  def create
    @comment = Comment.new(comment_params.merge(
      commentable: @instance, user: current_user
    ))
    @comment.save
  end

  def edit
    @comment = Comment.find(params[:id])
    owner_or_admin_access
  end

  def cancel_edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment =  Comment.find(params[:id])
    owner_or_admin_access
    @comment.update(comment_params)
  end

  def destroy
    @comment = Comment.find(params[:id])
    owner_or_admin_access
    @comment.destroy
  end

  def preview
    @comment = params[:comment]
    render layout: false
  end

  def response_to
    @comment = Comment.find(params[:id])
  end

  protected
  def comment_params
    params.permit(:text,:response_to_id)
  end

  def set_instance
    klass = params[:commentable_resource].singularize.camelize.constantize
    if klass.is_a? FriendlyId
      @instance = klass.friendly.find(params[:id])
    else
      @instance = klass.find(params[:id])
    end
  end

  def owner_or_admin_access
    is_admin = signed_in? && current_user.is_admin?
    is_owner_of_comment = signed_in? && @comment.user.id == current_user.id
    if(!is_admin && !is_owner_of_comment)
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
