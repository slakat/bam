app.factory("RequestPartnerService", ['$resource',function($resource) {
    return $resource("/request_partner_services/:id", { id: "@id" },
        {
            'index':   { method: 'GET', isArray: true },
            'show':    { method: 'GET', isArray: false },
            'update':  { method: 'PUT' }
        }
    );
}]);