// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require codemirror
//= require codemirror/ruby
//= require codemirror/xml
//= require codemirror/css
//= require codemirror/javascript
//= require codemirror/htmlmixed
//= require underscore-1.8.2
//= require backbone-1.1.2
//= require canvasjs-1.6.1
//= require moment
//= require moment/es.js
//= require nested_form_fields
//= require zeroclipboard
//= require datepicker/bootstrap-datepicker
//= require datepicker/bootstrap-datepicker.es.js
//= require intlTelInput
//= require jquery.payment
//= require_tree .

Turbolinks.enableProgressBar();

$(document).on("page:fetch", function() {
  $(document).off("page:before-change");
  Dispatcher.stopListening();
  save_files_timer.cancel();
});

$(document).on("page:change", function() {
  $('[data-toggle="tooltip"]').tooltip();
  $('body').on('click', '.close-overlay', function() {
    $('.overlay').hide();
  });
})

_.templateSettings = {
  interpolate: /\{\{=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g,
};

function invalidField(field, message) {
  $(field).parents(".form-group").addClass("has-error").append('<span class="help-block">' + message + '</span>');
}

function clearField(field) {
  $(field).parents(".form-group").removeClass("has-error");
  $(field).parents(".form-group").find(".help-block").remove();
}
