class SeatView extends Backbone.View
  el: '.reserve-seat-page'

  initialize: ->
    $.getJSON("https://ipinfo.io?token=dbb0f38cf907e8")
      .done((response) =>
        country = response.country
        countries = $.map($('#country options'), (option) -> option.value )
        if countries.indexOf(country)
          $('#country').val(country)
        else
          $('#country').val("")
      )
  
  events: ->
    "click .customer-id-type-dropdown li a": "customer_id_type_change"

  customer_id_type_change: (e) =>
    e.preventDefault()
    value = $(e.currentTarget).data("value")
    @.$("#customer-id-type").val(value)
    @.$(".customer-id-type-value").html(value)
    

window.SeatView = SeatView
