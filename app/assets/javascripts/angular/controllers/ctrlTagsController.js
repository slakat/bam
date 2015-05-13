app.controller("ctrlTags", ['$scope','$location', '$route','$routeParams','$parse',function($scope, $location,$route,$routeParams,$parse) {

    var tagsData = [
        {id:1,tag:'Apple'},
        {id:2,tag:'Banana'},
        {id:3,tag:'Cherry'},
        {id:4,tag:'Cantelope'},
        {id:5,tag:'Grapefruit'},
        {id:6,tag:'Grapes',selected:true},
        {id:7,tag:'Lemon'},
        {id:8,tag:'Lime'},
        {id:9,tag:'Melon',selected:true},
        {id:10,tag:'Orange'},
        {id:11,tag:'Strawberry'},
        {id:11,tag:'Watermelon'}
    ];

    function init(){

        $scope.items = tagsData;

    };

// init angular app and ctrls
    init();


}]);

