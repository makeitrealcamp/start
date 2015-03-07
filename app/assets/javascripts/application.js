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
//= require_tree .

Turbolinks.enableProgressBar();

$(document).on("page:fetch", function() {
  Dispatcher.stopListening();
  save_files_timer.cancel();
});

_.templateSettings = {
  interpolate: /\{\{=(.+?)\}\}/g,
  evaluate: /\{\{(.+?)\}\}/g,
};