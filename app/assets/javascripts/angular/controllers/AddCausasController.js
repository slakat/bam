app.controller('AddCausasController', ['$scope', '$http', '$interval', function($scope, $http, $interval){

    
    function add_causa(){
        $http.get('/accounts/add-causa', { params: query }).success(function(response){
            $scope.students = response;
        });

    }



    function init(){

        //$scope.items = tagsData;

    };

// init angular app and ctrls
    init();


}]);

