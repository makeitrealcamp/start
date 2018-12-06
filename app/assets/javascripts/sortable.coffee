class SortableView extends Backbone.View

  initialize: (opts)->
    @resource = opts.resource
    @$el.find("[data-sortable]").attr("draggable", true);

  events:
    "dragstart [data-sortable]": "handle_drag_start"
    "dragenter [data-sortable]": "handle_drag_enter"
    "dragover [data-sortable]": "handle_drag_over"
    "dragleave [data-sortable]": "handle_drag_leave"
    "drop [data-sortable]": "handle_drop"
    "dragend [data-sortable]": "handle_drag_end"

  handle_drag_start: (e)->
    $target = $(e.currentTarget)
    $target.css("opacity", 0.4)
    e.originalEvent.dataTransfer.setData("source_id", $target.attr("id"))

  handle_drag_over: (e)->
    e.preventDefault()

  handle_drag_enter: (e)->
    $(e.currentTarget).addClass("over")

  handle_drag_leave: (e)->
    $(e.currentTarget).removeClass("over")

  handle_drag_end: (e)->
    $target = $(e.currentTarget)
    $target.css("opacity",1)

    @$el.find("[data-sortable]").removeClass("over");

  handle_drop: (e)->
    e.stopPropagation()
    source_id = e.originalEvent.dataTransfer.getData("source_id");
    $source_el = $("##{source_id}");
    resource_id = $source_el.data("resource-id")

    $(e.currentTarget).before($source_el);
    @$el.find("[data-sortable]").each (index, el)->
      $(el).data("index", index);

    $.ajax({
      url: "/#{@resource}/#{resource_id}/update_position",
      type: "PATCH",
      contentType: "application/json",
      data: JSON.stringify({ position: $source_el.data("index") })
      dataType: "json"
    });


window.SortableView = SortableView
