var ready;
ready = function() {
  var initDate = moment().subtract(23, 'years')
  $("[data-datetimepicker]").datepicker({
    language: "es",
    format: "dd/mm/yyyy",
    orientation: 'bottom',
    defaultViewDate: { year: initDate.year() }
  });

  $("[data-intlTelInput]").intlTelInput();
}

$(document).ready(ready);
$(document).on("turbolinks:load", ready);
