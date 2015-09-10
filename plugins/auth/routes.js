//Add all the routes related to Auth Plugin here.
var Handler = require('./handlers');
var config = require('../../config/secret');
module.exports = [{
    path: config.twitter.callbackURL,
    method: "GET",
    config: {
        auth: 'twitter',
        handler: Handler.sessionManagement
    }
// }, {
//     path:  config.google.callbackURL,
//     method: "GET",
//     config: {
//         auth: 'google',
//         handler: Handler.sessionManagement
//     }

// }, {
//     path: "/logout",
//     method: "GET",
//     config: {
//         handler: function(request, reply) {
//             request.auth.session.clear();
//             return reply.redirect('/');
//         }
//     }

}];
