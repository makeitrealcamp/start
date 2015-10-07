var initHome;
initHome = function() {
  $('.home .new_site').on('click', '.scroll', function() {
    $('html,body').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
  var myCalendar = createCalendar({
    options: {
      class: 'add-to-calendar',
      id: 'add-to-calendar'                               // You need to pass an ID. If you don't, one will be generated for you.
    },
    data: {
      title: 'Sesión Informativa Make it Real',     // Event title
      start: new Date('October 25, 2015 19:00'),   // Event start date
      duration: 30,                            // Event duration (IN MINUTES)
      end: new Date('October 25, 2015 19:30'),     // You can also choose to set an end time.
                                                    // If an end time is set, this will take precedence over duration
      address: 'The internet',
      description: 'Descripción evento.'
    }
  });
  document.querySelector('.new-cal').appendChild(myCalendar);
  $('.home .new_site label[for]').on('click', function (e) {
    $(".info-session").toggleClass("change");
    var target = window[this.htmlFor];
    target.checked = !target.checked;
    e.preventDefault();
  });
};
$(document).on('page:load', initHome);