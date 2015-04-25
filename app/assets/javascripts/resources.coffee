class ResourceView extends Backbone.View
  el: 'body'

  initialize: ->
    @$resource_type = $("#resource_type")
    @show_resource_type_form(@$resource_type.val())
  events:
    "change #resource_type": "change_type"

  change_type: (e) ->
    @show_resource_type_form(@$resource_type.val())

  show_resource_type_form: (type)->
    $(".resource-type-form").hide()
    $(".type-#{type}-form").show()

window.ResourceView = ResourceView
