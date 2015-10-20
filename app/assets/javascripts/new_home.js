var ready;
ready = function() {
  $('.new_site .intro').on('click', '.scroll', function() {
    $('html,body').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
};
$(document).ready(ready);
$(document).on('page:load', ready);