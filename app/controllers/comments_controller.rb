class CommentsController < ApplicationController
  before_action :private_access
  before_action :set_instance, only: [:index, :create]

  # GET /:commentable_resource/:id/comments
  def index
    comments = @instance.comments.order("created_at DESC")
    render json: comments.to_json
  end

  # POST /:commentable_resource/:id/comments
  def create
    @comment = Comment.new(comment_params.merge(
      commentable: @instance, user: current_user
    ))
    @comment.save
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment =  Comment.find(params[:id])
    if params[:commit] == "Actualizar comentario"
      @comment.update(comment_params)
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  def preview
    @comment = params[:comment]
    render layout: false
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
end
