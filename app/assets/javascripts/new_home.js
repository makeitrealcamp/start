var initHome;
initHome = function() {
  $('.home .new_site').on('click', '.scroll', function() {
    $('html,body').animate({
    scrollTop: $('#anchor').offset().top - 75},
    'slow');
  });
  var startTime = moment().endOf('month').day('Thursday').hour('18');  // moment.js in local time
  var endTime = moment().endOf('month').day('Thursday').hour('19');  // moment.js in local time
  var myCalendar = createCalendar({
    options: {
      class: 'add-to-calendar',
      id: 'add-to-calendar'                               // You need to pass an ID. If you don't, one will be generated for you.
    },
    data: {
      title: 'Sesión Informativa Make it Real',     // Event title
      start: new Date(startTime),   // Event start date
      duration: 60,                            // Event duration (IN MINUTES)
      end: new Date(endTime),     // You can also choose to set an end time.
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