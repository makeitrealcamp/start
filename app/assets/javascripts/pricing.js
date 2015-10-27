var ready_pricing;
ready_pricing = function() {

  // cambiar tipo de moneda
  $.get("http://ipinfo.io", function(response) {
    if(response.country == "CO") {
      $("#financing").html("<div class='primera-cuota'><span class='price-one'>$800,000</span></br>Primera cuota</div>" + "<div class='plus'>+</div>" + "<div class='otras-cuotas'><span class='price-one'>$320,000</br></span>5 cuotas mensuales</div>" + "<p class='valor-total'>O paga <span class='directo'>$2,060,000</span> de entrada y ahorra <span class='valor-ahorro'>$340,000</span></p>" + "<div class='caption'><p>Recibimos todos los medios de pago. Precios en <strong>pesos colombianos</strong>.</p></div>");
    }
    else {
      $("#financing").html("<div class='primera-cuota'><span class='price-one'>$299</span></br>Primera cuota</div>" + "<div class='plus'>+</div>" + "<div class='otras-cuotas'><span class='price-one'>$150</br></span>5 cuotas mensuales</div>" + "<p class='valor-total'>O paga <span class='directo'>$900</span> de entrada y ahorra <span class='valor-ahorro'>$149</span></p>" + "<div class='caption'><p>Recibimos todos los medios de pago. Precios en <strong>dólares americanos</strong>.</p></div>");
    }
  }, "jsonp"); 

  // rotar quotes
  var divs = $('div[id^="student-says-"]').hide(),
    i = 0;
  (function cycle() { 

      divs.eq(i).fadeIn(400)
                .delay(10000)
                .fadeOut(400, cycle);

      i = ++i % divs.length;

  })();
};
$(document).ready(ready_pricing);
$(document).on("page:load", ready_pricing);