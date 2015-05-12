app.controller("SelectRequestPartnerServiceController", ['$scope','$location','ServiceSchedule','RequestPartnerService', '$route','$routeParams',function($scope, $location, ServiceSchedule,RequestPartnerService,$route,$routeParams) {

    var div = document.getElementById('div-item-data');

    var _slots = [

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0]

    ];

    var _open_slots = eval(div.getAttribute("data-item-selected"));
    var _days_range= div.getAttribute("data-item-days").split(",");
    console.log(_days_range);

    var _days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
    var _mods =['8:30','10:00','11:30','14:00','15:30','17:00','18:30','20:00'];
    var _mods_end =['9:50','11:20','12:50','15:20','16:50','18:20','19:50','21:20'];

    var _selection = {

        state: false,

        day: [0, 0, 0, 0, 0, 0, 0],

        hour: [0, 0, 0, 0, 0, 0, 0, 0]

    };


    function _loop(begin, end, step) {

        var array = [];



        for (var i = begin; i <= end; i += step) {

            array.push(i);

        }



        return array;

    }

    function _toggle(what, day, hour) {

        var i = 0;



        switch (what) {

            case 'day':

                _selection.day[day] = !_selection.day[day];

                for (i = 0; i < 8; i++) {
                    _slots[day][i] = _selection.day[day];
                    document.getElementById([day]+"-"+[i]).click();

                }

                break;



            case 'hour':

                _selection.hour[hour] = !_selection.hour[hour];


                for (var i = 0; i < 5; i++) {
                    alert(i);
                    _slots[i][hour] = _selection.hour[hour];
                    document.getElementById([i]+"-"+[hour]).click();

                }

                break;



            case 'slot':

                if (_selection.state ) {
                    $scope.slots[day][hour] = !$scope.slots[day][hour];
                    //var selected = _.filter($scope.slots, function(slot){ return console.log[slot]; slot == true; });
                    var selected = _.size(_.filter(_.reduceRight($scope.slots, function(a, b) { return a.concat(b); }, []),function(num){ return num ===true; }));
                    //var selected = _.map($scope.slots, function(subarr) {
                        //return console.log(subarr);_.filter(subarr, true)
                    //})

                    if (selected > 1 ){
                        $scope.slots[day][hour] = !$scope.slots[day][hour];
                        document.getElementById([day]+"-"+[hour]).click();
                    }
                    else if( _disable_slot(day,hour)){
                        $scope.slots[day][hour] = !$scope.slots[day][hour]
                    }

                }

                break;

        }

    }



    function _select(state, day, hour) {

        _selection.state = state;

        if (_selection.state) {

           _toggle('slot', day, hour);
        }

    }
    // function to set the default data
    $scope.reset = function() {
        $route.reload();

    };

    $scope.service = new ServiceSchedule();
    var _request = new RequestPartnerService.show({ id: $routeParams.id });

    $scope.submit = function(){

            var allGood = true;

            for (var j = 0; j <= 4; j += 1) {

                for(var i=0;i<=7;i+=1){

                    if($scope.slots[j][i]===true){
                        $scope.service.week_day= $scope.days[j];
                        $scope.service.time_module =  i+1;
                        $scope.service.start_time = _days_range[j]+" "+$scope.mods[i];
                        $scope.service.end_time = _days_range[j]+" "+$scope.mods_end[i];
                        $scope.service.service_activity_id = $scope.data.service_id;
                        $scope.service.service_activity_type = "PartnerService";
                        _request.event_date = _days_range[j]+" "+$scope.mods[i];
                        console.log(_days_range[j]);

                    }

                }

            }

            ServiceSchedule.create($scope.service, function success(){
                console.log('Tutoría creada exitosamente.');
            }, function failure(response) {
                allGood = false;
                console.error(response);
            })


            if(allGood===false){
                alert('Ha ocurrido un error al guardar la tutoría');
            }
            else {
                _request.id = $routeParams.id
                _request.state = 3;
                _request.$update( function success(){
                    console.log('Tutoría creada exitosamente.');
                }, function failure(response) {
                    console.error(response);
                });
                $('#link_service').toggle();
                var earl = '/select_schedule/success';
                $location.url(earl);
            }

    };

    function _disable_slot(day,hour){
        if (_open_slots[day][hour]===true){
            return false
        }
        else
            return true

    }


    function _init() {
        $scope.data =  {id: div.getAttribute("data-item-id"),
            service_id: div.getAttribute("data-item-service")};
        $scope.slots = _slots;
        $scope.days = _days;
        $scope.mods_end = _mods_end;
        $scope.select = _select;
        $scope.toggle = _toggle;
        $scope.loop = _loop;
        $scope.mods = _mods;
        $scope.disable_slot = _disable_slot;

    }



    _init();


    }]);

