class AdminWebinarView
  constructor: (options) ->
    new SlugGenerator(
      source: $('#webinars_webinar_title')
      target: $('#webinars_webinar_slug')
      checked: options.new_record
    )


window.AdminWebinarView = AdminWebinarView
