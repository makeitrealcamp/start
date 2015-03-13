class ResourceView extends Backbone.View
  el: 'body'

  events:
    "change #resource_type": "change_type"

  change_type: (e) ->
    type = $(e.currentTarget).val()
    if type == "markdown"
      $('.url-field').hide()
      $('.content-field').show()
    else
      $('.url-field').show()
      $('.content-field').hide()

window.ResourceView = ResourceView