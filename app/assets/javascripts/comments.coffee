class CommentsView extends Backbone.View
  el: '.discussion'

  initialize: ->
    @$btn_send_comment = @$(".btn-send-comment")

  events:
    'focus form': 'focus_comment_input'
    'focusout form': 'focus_out_comment_input'

  focus_comment_input: ->
    @$btn_send_comment.removeClass("hidden")

  focus_out_comment_input: ->
    @$btn_send_comment.addClass("hidden")

window.CommentsView = CommentsView
