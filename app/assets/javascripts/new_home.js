$( document ).ready(function() {
  $('.new_site').on('click', '.scroll', function() {
    $('html').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
});

