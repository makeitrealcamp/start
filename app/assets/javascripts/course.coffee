class CourseLandingView extends Backbone.View
  el: '#registration-modal'

  initialize: ->
    @step = 1

  render: ->
    $(@el).on('shown.bs.modal', =>
      @before_step_1()

      $.getJSON("//ipinfo.io")
        .done((response) =>
          country = response.country
          countries = $.map($('#country options'), (option) -> option.value )
          if countries.indexOf(country)
            @.$('#country').val(country)
            @show_mobile()
          else
            @.$('#country').val("")
            @.$('#mobile-wrapper').hide()
        )
    ).modal()

  show_mobile: ->
    @.$('#mobile-code').html('+' + $('#country option:selected').data('code'))
    @.$('#mobile-wrapper').show()

  events: ->
    "click .next": "handle_navigation"
    "click .back": "navigate_back"
    "click .clean-invoice": "clean_invoice"
    "click .customer-id-type-dropdown > li > a": "change_customer_id_type"
    "click .finish": "submit_form"
    "change #country": "change_country_code"

  change_country_code: ->
    country = $('#country').val()
    if (country != "")
      @show_mobile()
      $('#mobile').focus()
    else
      $('#mobile-wrapper').hide()


  submit_form: ->
    @.$('.step-2 .form-group').removeClass('has-error')

    valid = true
    valid = false if !@input_text_is_valid($('#invoice-name'))
    valid = false if !@input_text_is_valid($('#customer-id'))
    valid = false if !@input_text_is_valid($('#invoice-email'))
    valid = false if !@input_text_is_valid($('#country'))
    valid = false if !@input_text_is_valid($('#mobile'))
    valid = false if !@input_text_is_valid($('#invoice-address'))

    if valid
      @.$('.header-logo').addClass('spin')
      @.$('.finish').attr('disabled', true)

      @.$('#registration-form')[0].submit()

  handle_navigation: (e) ->
    e.preventDefault()

    @.$('.header-logo').addClass('spin')
    @['after_step_' + @step]((valid, action) =>
      @.$('.header-logo').removeClass('spin')
      @.$('.next').attr('disabled', false)

      action() if action
    )

  navigate_next: =>
    @navigate(1)

  navigate_back: (e) ->
    e.preventDefault()
    @navigate(-1)

  navigate: (direction) ->
    @.$('.step-' + @step).hide()
    @step = @step + direction

    @.$('.step-' + @step).show()
    @['before_step_' + @step]() # before step callback

    @.$('.header-step > div').removeClass('active')
    @.$('.header-step-' + @step).addClass('active')

    @show_or_hide_buttons()

  show_or_hide_buttons: ->
    if @step > 1 then @.$('.back').show() else @.$('.back').hide()
    if @step == 2
      @.$('.next').hide()
      @.$('.finish').show()
    else
      @.$('.next').show()
      @.$('.finish').hide()

  clean_invoice: (e) ->
    e.preventDefault()

    @.$('#invoice-name').attr('readonly', false).val('')
    @.$('#invoice-email').attr('readonly', false).val('')
    @.$('.clean-invoice').remove()
    @.$('#invoice-name').focus()

  change_customer_id_type: (e) ->
    e.preventDefault()

    value = $(e.currentTarget).html()
    @.$('#customer-id-type').val(value)
    @.$('.customer-id-type-value').html(value)
    @.$('#customer-id').focus()

  before_step_1: ->
    @.$('#first-name').focus()

  after_step_1: (callback) ->
    @.$('.step-1 .form-group').removeClass('has-error')

    valid = true
    valid = false if !@input_text_is_valid($('#first-name'))
    valid = false if !@input_text_is_valid($('#last-name'))
    valid = false if !@input_text_is_valid($('#email'))

    if valid
      _dp('track', 'performed-course-charge-step-1',
          person:
            first_name: $('#first-name').val()
            last_name: $('#last-name').val()
            email: $('#email').val()
      )
      @navigate_next()

    callback(valid)

  before_step_2: ->
    @.$('.step-2 .instructions').html("Ingresa los datos para la " +
        "elaboración de la factura:")

    name = @.$('#first-name').val() + " " + @.$('#last-name').val()
    @.$('#invoice-name').val(name)
    @.$('#invoice-email').val(@.$('#email').val())

    @.$('#customer-id').focus()

  input_text_is_valid: (field, message) ->
    if field.val().replace(/\s+/, '').length == 0
      field.closest('.form-group').addClass('has-error')
      return false
    return true


window.CourseLandingView = CourseLandingView
