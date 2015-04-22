class CommentsView extends Backbone.View
  el: '.discussion'

  initialize: (commentable_url, current_user)->
    @resource_url = commentable_url
    @current_user = current_user
    @comment_template = _.template($("#comment-template").html())
    @$comments_container = @$(".comments")
    @$comments_input = @$("textarea")
    @$btn_send_comment = @$(".btn-send-comment")

    @load_comments()

  events:
    'focus form': 'focus_comment_input'
    'focusout form': 'focus_out_comment_input'
    'submit form': 'submit_form'

  submit_form: (e)->
    e.preventDefault()
    @publish_comment()

  publish_comment: ->
    text = @$comments_input.val()
    $comment = $(@comment_template(
      author: @current_user.first_name
      text: text
      avatar_url: @current_user.avatar_url
      date: Date.now()
    ))
    @$comments_container.prepend($comment)
    @$comments_input.val("")

    $.ajax
      url: @resource_url
      method: "POST"
      data: { text: text }
      error: ->
        $comment.remove()





  focus_comment_input: ->
    @$btn_send_comment.removeClass("hidden")

  focus_out_comment_input: ->
    @$btn_send_comment.addClass("hidden")


  load_comments: ->
    $.getJSON @resource_url, (comments)=>
      comments = $.map comments, (comment)=>
        @comment_template(
          author: comment.user.first_name
          text: comment.text
          avatar_url: comment.user.avatar_url
          date: comment.created_at
        )
      @$comments_container.append comments


window.CommentsView = CommentsView
