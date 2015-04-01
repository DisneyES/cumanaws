// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require adaptativo
//= require_tree .

$(function(){
    $(window).scroll(function(){
        if($(window).scrollTop()>40){
            $('#cabezal').addClass('scroll');
//            $('.fa').removeClass('fa-5x');
//            $('.fa').addClass('fa-3x');
        }
        else{
            $('#cabezal').removeClass('scroll');
//            $('.fa').removeClass('fa-3x');
//            $('.fa').addClass('fa-5x');
        }
    });
});