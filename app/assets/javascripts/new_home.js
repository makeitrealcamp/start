var ready;
ready = function() {
  $('.home .new_site').on('click', '.scroll', function() {
    $('html,body').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
};
$(document).ready(ready);
$(document).on('page:load', ready);