validator =
  validate_field: (selector, valid_fn, message) ->
    form_group = selector.closest('.form-group')
    form_group.removeClass("has-error")
    $('.help-block', form_group).remove()

    value = selector.val();
    if !valid_fn(value)
      selector.closest('.form-group').addClass("has-error").append('<span class="help-block">' + message + '</span>')
      return false

    return true

  is_blank: (val) -> val.trim().length != 0
  is_email: (val) -> /(.+)@(.+){2,}\.(.+){2,}/.test(val)
  is_mobile: (val) -> /[0-9\-()\+\s]{7,20}/.test(val)

class CourseView extends Backbone.View
  initialize: (opts) ->
    super(opts)
    console.log(validator)

    $(window).on('scroll', =>
      scroll = $(window).scrollTop()
      if scroll > 600
        $('.header-register').slideDown()
      else
        $('.header-register').slideUp()
    )

  events: ->
    "click .btn-register": "open_modal"

  open_modal: ->
    form = new CourseFormModal()
    form.render()

class CourseFormModal extends Backbone.View
  el: '#registration-modal'

  initialize: ->
    @detect_country()

  detect_country: ->
    $.getJSON("//ipinfo.io?token=dbb0f38cf907e8")
      .done((response) =>
        country = response.country
        $('#form-register #country', @el).val(country)
      )

  render: ->
    $(@el).on('shown.bs.modal', =>
      $('#first-name').focus()
    ).modal()

  events: ->
    "submit #form-register": "submit_form"

  submit_form: ->
    valid = @validate_form()
    return false if !valid

  validate_form: =>
    valid = true
    if !validator.validate_field($('#form-register #first-name'), validator.is_blank, "Campo requerido")
      $('#form-register #first-name').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #last-name'), validator.is_blank, "Campo requerido")
      $('#form-register #last-name').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #email'), validator.is_blank, "Campo requerido")
      $('#form-register #email').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #email'), validator.is_email, "Email inválido")
      $('#form-register #email').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#country'), validator.is_blank, "Campo requerido")
      $('#form-register #country').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#source'), validator.is_blank, "Campo requerido")
      $('#form-register #source').one('change', @validate_form)
      valid = false

    return valid

class WomenScholarshipsView extends Backbone.View
  el: '.fs-becas-mujeres'

  initialize: ->
    $(window).on('scroll', =>
      scroll = $(window).scrollTop()
      if scroll > 600
        $('.header-register').slideDown()
      else
        $('.header-register').slideUp()
    )

    $.getJSON("//ipinfo.io?token=dbb0f38cf907e8")
      .done((response) =>
        country = response.country
        $('#form-register #country').val(country)

        val = "USD$55"
        val = "COP$180,450" if country == "CO"
        val = "MXN$1,123" if country == "MX"
        val = "PEN$174" if country == "PE"
        $(".section-faq .program-value").html(val)
      )

  events: ->
    "click .btn-register": "open_modal"
    "submit #form-register": "submit_form"

  open_modal: ->
    $("#registration-modal").on('shown.bs.modal', =>
      $('#first-name').focus()
    ).modal()

  submit_form: ->
    valid = @validate_form()
    return false if !valid

  validate_form: =>
    valid = true
    if !validator.validate_field($('#form-register #first-name'), @is_blank, "Campo requerido")
      $('#form-register #first-name').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #last-name'), @is_blank, "Campo requerido")
      $('#form-register #last-name').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #email'), @is_blank, "Campo requerido")
      $('#form-register #email').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#form-register #email'), @is_email, "Email inválido")
      $('#form-register #email').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#country'), @is_blank, "Campo requerido")
      $('#form-register #country').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#age'), @is_blank, "Campo requerido")
      $('#form-register #age').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#application-reason'), @is_blank, "Campo requerido")
      $('#form-register #application-reason').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#url'), @is_blank, "Campo requerido")
      $('#form-register #url').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#source'), validator.is_blank, "Campo requerido")
      $('#form-register #source').one('change', @validate_form)
      valid = false

    return valid

window.CourseView = CourseView
window.WomenScholarshipsView = WomenScholarshipsView
