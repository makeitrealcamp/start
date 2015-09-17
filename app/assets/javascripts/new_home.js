$( document ).ready(function() {
  $('.scroll').click(function(){
    $('html').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
});

