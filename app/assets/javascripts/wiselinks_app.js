$(document).ready(function(){

    var mainContainer = '#main-container';
    var $modal = $('#main-modal').modal({ show: false});
    var $body = $('#main-modal-body');

    $modal.on('hidden.bs.modal', function(){
        clearBody();
    });

    function clearBody(){
        $body.html('');
    }

    function showModal(){
        $modal.modal('show');
        var self = $modal.data('bs.modal');
        self.$element.on('click.dismiss.bs.modal', function(e){
            if (e.target !== e.currentTarget) return;
            History.back(1);
            clearBody();
        });
    }

    function hideModal(){
        if($modal.data('bs.modal').isShown){
            $modal.modal('hide');
        }
    }

    // Wiselinks Initilization

    window.wiselinks = new Wiselinks($(mainContainer), { target_missing: 'exception' });

    $(document).off('page:done').on('page:done', function(event, $target, status, url, data) {

        $(document).trigger('page:load');

        if ($target.attr('id') === 'main-modal-body')
            showModal();
        else
            hideModal();

        googleAnalytics(url);

    });

    // Google Analytics Patch for Wiselinks

    function googleAnalytics(url){
        if(typeof _gaq !== 'undefined'){
            _gaq.push(['_trackPageview', url]);
            _metrika.hit(url);
        }
    }

});