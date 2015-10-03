//= require ouical.min
var ready;
ready = function() {
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
      title: 'Get on the front page of HN',     // Event title
      start: new Date('June 15, 2013 19:00'),   // Event start date
      duration: 120,                            // Event duration (IN MINUTES)
      end: new Date('June 15, 2013 23:00'),     // You can also choose to set an end time.
                                                    // If an end time is set, this will take precedence over duration
      address: 'The internet',
      description: 'Get on the front page of HN, then prepare for world domination.'
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
$(document).ready(ready);
$(document).on('page:load', ready);