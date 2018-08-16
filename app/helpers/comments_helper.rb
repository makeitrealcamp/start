module CommentsHelper

  def generate_comments_path(commentable_instance)
    klass = commentable_instance.class
    resource_name = klass.to_s.underscore
    if klass.is_a? FriendlyId
      id = commentable_instance.friendly_id || commentable_instance.id
    else
      id = commentable_instance.id
    end
    Rails.application.routes.url_helpers.comments_path(commentable_resource: resource_name, id: id)
  end

  def button_edit(comment)
    link_to '<span class="glyphicon glyphicon-pencil"></span>'.html_safe , edit_comment_path(comment), remote: true, id:"edit-coment-#{comment.id}", title: "Editar Comentario"
  end

  def button_delete(comment)
    link_to '<span class="glyphicon glyphicon-remove"></span>'.html_safe  , comment_path(comment), remote: true, data: {confirm: "¿Estás seguro de eliminar el comentario?"}, method: :delete, id:"remove-coment-#{comment.id}", title: "Eliminar Comentario"
  end

end
