$(document).on('ready page:load', function(event) {
  $('.home .new_site').on('click', '.scroll', function() {
    $("html,body").animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
});