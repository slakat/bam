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
//= require dataTables/jquery.dataTables
//= require dataTables/extras/dataTables.responsive
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.foundation
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/jquery.dataTables
//= require bootstrap
//= require select2
//= require jquery_nested_form
//= require jquery.datetimepicker
//= require gritter
//= require wiselinks
//= require underscore
//= require best_in_place

//= require angular
//= require angular-route
//= require angular-resource
//= require angular-animate
//= require ui-bootstrap-tpls-0.12.1.js
//= require loading-bar
//= require ui-select
//= require ./angular/app
//= require flat-ui.min
//= require radiocheck

//= require_self
//= require_tree .

$(function(){

    $('.datatable').DataTable({
        responsive: true,
        // ajax: ...,
        // autoWidth: false,
         pagingType: 'simple_numbers'
        // processing: true,
         //serverSide: true,

        // Optional, if you want full pagination controls.
        // Check dataTables documentation to learn more about available options.
        // http://datatables.net/reference/option/pagingType
    });


    $(':checkbox').radiocheck();
    $('[data-toggle="checkbox"]').radiocheck();
    $('[data-toggle="radio"]').radiocheck();
    $('[data-toggle="dropdown"]').dropdown();
    // Switches
    if ($('[data-toggle="switch"]').length) {
        $('[data-toggle="switch"]').bootstrapSwitch();
    }

    if ($('[data-toggle="select"]').length) {
        $('[data-toggle="select"]').select2();
    }

    $("#custom-switch-01").on("click", function(act_id) {
        alert("hola");
        $.ajax({
            url: "/controller/done",
            beforeSend: function() { alert("Hi") },
            data: "id="+act_id,
            success: function() { alert('Bye') }
        });
    });

    $('input[id="custom-switch-01"]').on('switchChange.bootstrapSwitch', function(event, state) {
        //console.log(this); // DOM element
        //console.log(event); // jQuery event
        //console.log(state); // true | false

        var info = this.name.split("_");
        console.log(info[1]);

        var tracking = 2; //OFF
        if(state)
        {
            tracking = 1; //ON

        }

        $.ajax({
            type:'PUT',
            url: "/user_causa/"+info[1],
            beforeSend: function() { console.log("working") },
            data: "user_causa["+info[0]+"]="+tracking,
            success: function() { console.log("success") }
        });
    });
});

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
    $(".select2-bh").select2();
    $(".best_in_place").best_in_place();

});

function initDataBehaviour(container_id) {
    var select2s = $("[data-behaviour='select2']", container_id);
    select2s.select2();
}



function initBla(id) {
    $(".select2-search").show();

    function formatRepo (repo) {

        var markup = '<div class="clearfix">' +
            '<div class="col-sm-1">' +
            '<i class="fa fa-book"></i>' +
            '</div>' +
            '<div clas="col-sm-10">' +
            '<div class="clearfix">' +
            '<div class="col-sm-5">' + repo.identificator + '</div>' +
            '<div class="col-sm-5">' + repo.tribunal + '</div>' +
            '</div>';

        if (repo.caratulado) {
            markup += '<div> <b>Caratulado: </b>' + repo.caratulado + '</div>';
        }

        markup += '</div></div>';

        return markup;
    }

    function formatRepoSelection (repo) {
        return repo.caratulado
    }

    var courses = $('#account_id', id);

    courses.css('width', '100%');
    courses.select2({

        ajax: {
            url: window.location.origin.replace(/#.*$/, "") + '/search_add_causa',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params,c: $('#competencia_select').val()
                };
            },
            results: function (data, params) {
                // parse the results into the format expected by Select2
                // since we are using custom formatting functions we do not need to
                // alter the remote JSON data, except to indicate that infinite
                // scrolling can be used
                params.page = params.page || 1;
               /* return {
                    results: _.map(data, function(course){
                        return _.extend(course, { text: 'Rit: '+course.rit.toString() + ', RUC, ' + course.ruc.toString() +', Caratulado: '+course.caratulado });
                    })
                };
            },
            cache: false
        },
        minimumInputLength: 3*/
                var results = [];
                $.each(data, function(index, item) {
                    results.push({
                        text: item.caratulado,
                        text: item.identificator
                    });
                });
                return {
                    results: data
                };
            },
            cache: true
        },
        escapeMarkup: function (markup) { return markup; },
        minimumInputLength: 3,
        formatResult: formatRepo,
        formatSelection: formatRepoSelection,
        dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller


    });
}

function initClients(id) {
    $(".select2-search").show();

    function formatRepo (repo) {

        var markup = '<div class="clearfix">' +
            '<div class="col-sm-1">' +
            '<i class="fa fa-book"></i>' +
            '</div>' +
            '<div clas="col-sm-10">' +
            '<div class="clearfix">' +
            '<div class="col-sm-5">' + repo.name +'</div>' +
            '<div class="col-sm-5">' + repo.rut + '</div>' +
            '</div>';


        markup += '</div></div>';

        return markup;
    }

    function formatRepoSelection (repo) {
        return repo.name
    }

    var courses = $('#account_id', id);

    courses.css('width', '100%');
    courses.select2({

        ajax: {
            url: window.location.origin.replace(/#.*$/, "") + '/search_clients',
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
                /* return {
                 results: _.map(data, function(course){
                 return _.extend(course, { text: 'Rit: '+course.rit.toString() + ', RUC, ' + course.ruc.toString() +', Caratulado: '+course.caratulado });
                 })
                 };
                 },
                 cache: false
                 },
                 minimumInputLength: 3*/
                var results = [];
                $.each(data, function(index, item) {
                    results.push({
                        text: item.id,
                        text: item.rut
                    });
                });
                return {
                    results: data
                };
            },
            cache: true
        },
        escapeMarkup: function (markup) { return markup; },
        minimumInputLength: 3,
        formatResult: formatRepo,
        formatSelection: formatRepoSelection,
        dropdownCssClass: "bigdrop", // apply css that makes the dropdown taller


    });
}