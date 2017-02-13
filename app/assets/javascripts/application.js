//= require_self
//= require bootstrap-sprockets
//= require react_ujs
//= require jquery_ujs
//= require js.cookie
//= require js-routes

window.$ = window.jQuery = global.$ = require('jquery');
var React = window.React = global.React = require('react');
var ReactDOM = window.ReactDOM = global.ReactDOM = require('react-dom');

require('./components');

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
  if (!Cookies.get('splashed')) {
    Cookies.set('splashed', 'true', { expires: 2});
    $('#splash-modal').modal('show');
  }
});
