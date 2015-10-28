
window.ready_pricing = function() {
  // cambiar tipo de moneda
  $.get("http://ipinfo.io", function(response) {
    if(response.country == "CO") {
      $("#financing-cop").show();
    }
    else {
      $("#financing-usd").show();
    }
  },"json").fail(function() {
    $("#financing-cop").show();
  });

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
