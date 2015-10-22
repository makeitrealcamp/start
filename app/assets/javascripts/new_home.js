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
        $("#financing").html("Si eliges financiación, paga 1 cuota de COP$690,000 y 6 de COP$349,000.");
    }
    else {
        $("#currency").html("US$900");
        $("#financing").html("Si eliges financiación, paga 1 cuota de US$299 y 5 de US$150.");
    }
  }, "jsonp"); 
};
$(document).ready(ready);
$(document).on('page:load', ready);