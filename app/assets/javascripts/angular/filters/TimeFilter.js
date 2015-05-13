app.filter('time', function() {

    function countilize(count, string){
        if(count == 1)
            return count + " " + string;
        else
            return count + " " + string + "s";
    }

    return function(minutes) {

        if(!_.isNumber(minutes) || _.isNaN(minutes) || !_.isFinite(minutes))
            return 'N/A';

        if(minutes < 60)
            return countilize(minutes, 'minuto');


        var hours = Math.floor(minutes / 60);
        minutes = minutes % 60;

        if(minutes > 0)
            return countilize(hours, 'hora') + " y " + countilize(minutes, 'minuto');
        else
            return countilize(hours, 'hora');

    };
});