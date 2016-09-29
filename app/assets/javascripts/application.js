// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require autocomplete-rails

//= require bootstrap-sprockets
//= require react
//= require react_ujs
//= require components
//= require turbolinks
//= require_tree .

function getGeoLocation() {
  navigator.geolocation.getCurrentPosition(setGeoCookie);
}

function setGeoCookie(position) {
  var cookie_val = position.coords.latitude + "|" + position.coords.longitude;
  document.cookie = "lat_lng=" + escape(cookie_val);
}

$(document).ready(function(){
    $('.toggler').click(function(e){
      $(this).parent().children().toggle();  //swaps the display:none between the two spans
      $(this).parent().parent().find('.toggled_content').slideToggle();  //swap the display of the main content with slide action
  }); 
});
