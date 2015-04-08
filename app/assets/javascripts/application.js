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
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require jquery-ui
//= require jquery.validate.min
//= require bootstrap-select
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){
  $("form").on("keypress", function (e) {
    if (e.keyCode == 13) {
      return false;
    }
  });

  $("#user_password").focus(function(){
        this.type = "text";
    }).blur(function(){
        this.type = "password";
    })
})
