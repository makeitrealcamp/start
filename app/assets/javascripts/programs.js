$(function() {
  $(window).on('scroll', function() {
    var scroll = $(window).scrollTop();
    if (scroll > 600) {
      $('.header-apply').slideDown();
    } else {
      $('.header-apply').slideUp();
    }
  });
});
