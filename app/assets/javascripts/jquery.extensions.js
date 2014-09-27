jQuery.fn.filterByData = function(prop, val) {
    // Primero buscamos según los atributos DOM
    var byDataAttr = this.filter(
        function(){ return jQuery(this).attr(prop) == val; }
    );
    if(byDataAttr.length > 0)
        return byDataAttr;
    else
    // Si no encuentra, buscamos según función data de jQuery
        return this.filter(
            function() { return jQuery(this).data(prop)==val; }
        );
};

jQuery.fn.findByData = function(selector, key, val){
    if(arguments.length === 2){
        val = key;
        key = selector;
        selector = null;
    }
    selector = selector || '*';
    return this.find(selector).filterByData(key, val);
};