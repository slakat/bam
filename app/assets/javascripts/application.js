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
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require select2
//= require jquery_nested_form
//= require jquery.datetimepicker
//= require gritter
//= require wiselinks
//= require underscore


//= require angular
//= require angular-route
//= require angular-resource
//= require angular-animate
//= require ui-bootstrap-tpls-0.12.1.js
//= require loading-bar
//= require ui-select
//= require ./angular/app

//= require_self
//= require_tree .


function onInit(callback){
    $(document).ready(callback);
    $(document).on('page:load', callback);
}

function init_container(container_id){
    var select2s = $("[data-behaviour='select2']",container_id);
    select2s.select2({
        minimumResultsForSearch: 5
    });

    var popovers = $("[data-behaviour='popover']",container_id);
    popovers.popover();
}

function init_new_page(){
    init_container('body');
}


$(function(){init_new_page();})

onInit(function(){
    init_container('#main-container');
});


$(document).ready(function() {
    $("#areas_select").select2();

});

function initDataBehaviour(container_id) {
    var select2s = $("[data-behaviour='select2']", container_id);
    select2s.select2();
}

function initBla(id) {

    var courses = $('#account_id', id);

    courses.css('width', '100%');

    courses.select2({

        ajax: {
            url: window.location.pathname.replace(/#.*$/, "") + '/search',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params
                };
            },
            results: function (data, params) {
                // parse the results into the format expected by Select2
                // since we are using custom formatting functions we do not need to
                // alter the remote JSON data, except to indicate that infinite
                // scrolling can be used
                params.page = params.page || 1;
                return {
                    results: _.map(data, function(course){
                        return _.extend(course, { text: course.name + ' ' + course.lastname });
                    })
                };
            },
            cache: false
        },
        minimumInputLength: 3

    });
}