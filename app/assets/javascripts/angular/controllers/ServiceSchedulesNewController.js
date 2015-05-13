app.controller("ServiceSchedulesNewController", ['$scope','$location','ServiceSchedule', '$route',function($scope, $location, ServiceSchedule,$route) {

    var div = document.getElementById('div-item-data');

    var _slots = [

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0],

        [0, 0, 0, 0, 0, 0, 0, 0]

    ];


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

    };

    function _toggle(what, day, hour) {

        var i = 0;



        switch (what) {

            case 'day':

                _selection.day[day] = !_selection.day[day];



                for (i = 0; i < 8; i++) {

                    $scope.slots[day][i] = _selection.day[day];
                    _slots[day][i] = _selection.day[day];
                    document.getElementById([day]+"-"+[i]).click();

                }

                break;



            case 'hour':

                _selection.hour[hour] = !_selection.hour[hour];



                for (i = 0; i < 5; i++) {

                    $scope.slots[i][hour] = _selection.hour[hour];
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
                    console.log(selected);
                    if (selected > $scope.data.modules){
                        console.log(document.getElementById([day]+"-"+[hour]).checked);
                        $scope.slots[day][hour] = !$scope.slots[day][hour];
                        document.getElementById([day]+"-"+[hour]).click();


                    }

                }

                break;

        }

    };



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


    $scope.submit = function(){

            var events = [];
            var allGood = true;

            for (var j = 0; j <= 4; j += 1) {

                for(var i=0;i<=7;i+=1){

                    if($scope.slots[j][i]===true){
                        $scope.service.week_day= $scope.days[j];
                        $scope.service.time_module =  i+1;
                        if($scope.data.start === "0"){
                            $scope.service.start_time = $scope.data.end+" "+$scope.mods[i]
                        }
                        else{
                            $scope.service.start_time = $scope.data.start+" "+$scope.mods[i]}
                        $scope.service.end_time = $scope.data.end+" "+$scope.mods_end[i];
                        $scope.service.service_activity_id = $scope.data.id;
                        $scope.service.service_activity_type = $scope.data.type;
                        events.push($scope.service);
                        $scope.service = new ServiceSchedule()

                    }

                }

            }

            events.forEach(function(serv){
                ServiceSchedule.create(serv, function success(){
                    console.log('Tutoría creada exitosamente.');
                }, function failure(response) {
                    allGood = false;
                    console.error(response);
                })

        });
            if(allGood===false){
                alert('Ha ocurrido un error al guardar la tutoría');
            }
            else {
                $('#link_service').toggle();
                var earl = '/admin/service_schedules/success';
                $location.url(earl);
            }

    };



    function _init() {

        $scope.slots = _slots;
        $scope.days = _days;
        $scope.mods_end = _mods_end;
        $scope.select = _select;
        $scope.toggle = _toggle;
        $scope.loop = _loop;
        $scope.mods = _mods;
        $scope.data =  {id: div.getAttribute("data-item-id"),
            type: div.getAttribute("data-item-type"),
            start:   div.getAttribute("data-item-start"),
            end:   div.getAttribute("data-item-end"),
            modules: div.getAttribute("data-item-modules")
        };


    }



    _init();


    }]);

