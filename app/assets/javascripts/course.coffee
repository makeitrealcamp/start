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

        countries = $.map($('#country options'), (option) -> option.value)
        if countries.indexOf(country)
          $('#country').val(country)
          @show_mobile()
        else
          $('#country').val("")
          $('#mobile-wrapper').hide()
      )

  render: ->
    $(@el).on('shown.bs.modal', =>
      $('#first-name').focus()
    ).modal()

  events: ->
    "submit #form-register": "submit_form"
    "change #country": "update_country_code"

  update_country_code: ->
    country = $('#country').val()
    if country != ""
      @show_mobile();
      $('#mobile').focus();
    else
      $('#mobile-wrapper').hide();

  show_mobile: ->
    $('#mobile-code').html('+' + $('#country option:selected').data('code'))
    $('#mobile-wrapper').show()

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

    if !validator.validate_field($('#mobile'), validator.is_blank, "Campo requerido")
      $('#form-register #mobile').one('change', @validate_form)
      valid = false
    else if !validator.validate_field($('#mobile'), validator.is_mobile, "Número inválido")
      $('#form-register #mobile').one('change', @validate_form)
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

        countries = $.map($('#country options'), (option) -> option.value)
        if countries.indexOf(country)
          $('#country').val(country)
          @show_mobile()
        else
          $('#country').val("")
          $('#mobile-wrapper').hide()
      )

  events: ->
    "click .btn-register": "open_modal"
    "submit #form-register": "submit_form"
    "change #country": "update_country_code"

  update_country_code: ->
    country = $('#country').val()
    if country != ""
      @show_mobile();
      $('#mobile').focus();
    else
      $('#mobile-wrapper').hide();

  show_mobile: ->
    $('#mobile-code').html('+' + $('#country option:selected').data('code'))
    $('#mobile-wrapper').show()

  open_modal: ->
    $("#registration-modal").on('shown.bs.modal', =>
      $('#first-name').focus()
    ).modal()

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

    if !validator.validate_field($('#mobile'), validator.is_blank, "Campo requerido")
      $('#form-register #mobile').one('change', @validate_form)
      valid = false
    else if !validator.validate_field($('#mobile'), validator.is_mobile, "Número inválido")
      $('#form-register #mobile').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#birthday'), validator.is_blank, "Campo requerido")
      $('#form-register #birthday').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#application-reason'), validator.is_blank, "Campo requerido")
      $('#form-register #application-reason').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#url'), validator.is_blank, "Campo requerido")
      $('#form-register #url').one('change', @validate_form)
      valid = false

    if !validator.validate_field($('#source'), validator.is_blank, "Campo requerido")
      $('#form-register #source').one('change', @validate_form)
      valid = false

    return valid

class SponsorsView extends Backbone.View
  el: '.fs-sponsors'

  initialize: ->
    $(window).on('scroll', =>
      scroll = $(window).scrollTop()
      if scroll > 600
        $('.header-register').slideDown()
      else
        $('.header-register').slideUp()
    )

  events: ->
    "click .intro .scroll": "scroll"
    "click .btn-register": "open_modal"
    "submit #form-register": "submit_form"
    "click .scheme": "open_scheme"

  scroll: (e) ->
    e.preventDefault()
    $("html, body").animate({
      scrollTop: $("#schemes").offset().top
    }, "slow")

  open_scheme: (e) ->
    e.preventDefault()
    option = $(e.target).data("option")
    $("#registration-modal #course").val(option)
    @open_modal()

  open_modal: ->
    $("#registration-modal").on('shown.bs.modal', =>
      $('#first-name').focus()
    ).modal()

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

    if !validator.validate_field($('#form-register #course'), validator.is_blank, "Campo requerido")
      $('#form-register #course').one('change', @validate_form)
      valid = false

    return valid

window.CourseView = CourseView
window.WomenScholarshipsView = WomenScholarshipsView
window.SponsorsView = SponsorsView
