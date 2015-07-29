class BadgeView extends Backbone.View
  el: 'body'

  initialize: ->
    @giving_method = $("#badge_giving_method")
    @show_giving_method_form(@giving_method.val())
  events:
    "change #badge_giving_method": "change_method"

  change_method: (e) ->
    @show_giving_method_form(@giving_method.val())

  show_giving_method_form: (method)->
    $(".giving-method").hide()
    $(".giving-method-#{method}").show()

window.BadgeView = BadgeView
