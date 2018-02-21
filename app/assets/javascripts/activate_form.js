var ready;
ready = function() {
  $("[data-datetimepicker]").datepicker({
    language: "es",
    format: "dd/mm/yyyy",
    orientation: 'bottom'
  });

  $("[data-intlTelInput]").intlTelInput();
}

$(document).ready(ready);
$(document).on("page:load", ready);
