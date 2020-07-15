var ready = function() {
  // scroll para bajar en la intro
  $(".home .intro").on("click", ".scroll", function() {
    $("html,body").animate({
      scrollTop: $("#programs").offset().top
    }, "slow");
  });

  // agregar clase a div para poder meter imagen de background en login con slack
  $(function() {
    $("div.login").each(function(){
      $(this).closest('.expand').addClass("bg-login");
    })
  });
};
$(document).ready(ready);
$(document).on("turbolinks:load", ready);
