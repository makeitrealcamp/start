class ContentNavigationToggleView extends Backbone.View
  el: "#content_navigation_toggle"

  initialize: ->
    @closed = true
    @$overlay = $(".overlay")
    @$content_wrapper = $(".content-wrapper")
    @$sidebar_wrapper = $("#sidebar_wrapper")

  events:
    "click": "toggle_content_navigation"

  toggle_content_navigation: ->
    # toggle overlay
    # toggle no scroll body
    # toggle menu button
    # toggle menu
    if @closed
      @$el.removeClass("closed")
      @$el.addClass("opened")

      @$overlay.show()
      @$content_wrapper.addClass("no-scroll")

      @$sidebar_wrapper.addClass("opened")
      @$sidebar_wrapper.removeClass("closed")
    else
      @$el.addClass("closed")
      @$el.removeClass("opened")

      @$overlay.hide()
      @$content_wrapper.removeClass("no-scroll")

      @$sidebar_wrapper.removeClass("opened")
      @$sidebar_wrapper.addClass("closed")

    @closed = !@closed

    return

window.ContentNavigationToggleView = ContentNavigationToggleView
