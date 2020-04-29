class SlugGenerator
  constructor: (options) ->
    @source = options.source
    @target = options.target

    if options.checked
      @auto_slug()
      $('#auto-slug').prop('checked', true)

    $('#auto-slug').on 'change', @toggle_slug

  toggle_slug: (e) =>
    if $(e.target).is(":checked")
      @auto_slug()
    else
      @manual_slug()

  auto_slug: =>
    @generate_slug(@source.val() or "")

    @target.prop 'readonly', true
    @source.on 'keyup', => @generate_slug(@source.val())

  manual_slug: ->
    @target.prop('readonly', false).focus()
    @source.off 'keyup'

  generate_slug: (str) =>
    slug = @string_to_slug(str)
    @target.val(slug)

  string_to_slug: (str) =>
    str = str.replace(/^\s+|\s+$/g, '') # trim
    str = str.toLowerCase()

    # remove accents, swap ñ for n, etc
    from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;"
    to   = "aaaaeeeeiiiioooouuuunc------"

    for i in [0...from.length]
      str = str.replace(new RegExp(from.charAt(i), 'g'), to.charAt(i))

    str.replace(/[^a-z0-9 -]/g, '') # remove invalid chars
      .replace(/\s+/g, '-') # collapse whitespace and replace by -
      .replace(/-+/g, '-') # collapse dashes

window.SlugGenerator = SlugGenerator
