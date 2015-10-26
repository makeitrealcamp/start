var ready;
ready = function() {
  // scroll para bajar en la intro
  $('.new_site .intro').on('click', '.scroll', function() {
    $('html,body').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });

  // cambiar tipo de moneda
  $.get("http://ipinfo.io", function(response) {
    if(response.country == "CO") {
        $("#currency").html("COP$2'290,000");
        $("#financing").html("<li>" + "1 cuota inicial de COP$690,000" + " y " + "6 cuotas de COP$349,000." + "</li>");
    }
    else {
        $("#currency").html("USD$900");
        $("#financing").html("<li>" + "1 cuota inicial de USD$299" + " y " + "6 cuotas de USD$150." + "</li>");
    }
  }, "jsonp"); 
};
$(document).ready(ready);
$(document).on('page:load', ready);