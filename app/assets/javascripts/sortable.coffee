class Sortable
  constructor: (el, options) ->
    opts = {
      cursor: 'move',
      update: (event, ui) ->
        params = $(@).sortable('serialize', { key: 'positions[]' })
        $.ajax({
          url: ui.item.data('update-url'),
          type: "PATCH",
          data: params,
          dataType: "json"
        });
    }

    opts[key] = value for key, value of options

    $(el).sortable opts

window.Sortable = Sortable
