class SeatView
  constructor: () ->
    $.getJSON("https://ipinfo.io?token=dbb0f38cf907e8")
      .done((response) =>
        country = response.country
        countries = $.map($('#country options'), (option) -> option.value )
        if countries.indexOf(country)
          $('#country').val(country)
        else
          $('#country').val("")
      )

window.SeatView = SeatView
