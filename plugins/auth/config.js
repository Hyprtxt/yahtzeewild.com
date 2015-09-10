var Confidence = require("confidence");

var config = require('../../config/secret');

var store = new Confidence.Store({
    provider: {
        $filter: 'env',
        production: {
            twitter: {
                provider: 'twitter',
                password: 'hapiauth',
                clientId: '', // fill in your Twitter ClientId here
                clientSecret: '', // fill in your Twitter Client Secret here
                isSecure: false // Terrible idea but required if not using HTTPS
            },
            google: {
                provider: 'google',
                password: 'hapiauth',
                clientId: '', // fill in your Google ClientId here
                clientSecret: '', // fill in your Google Client Secret here
                isSecure: false // Terrible idea but required if not using HTTPS
            }
        }, // this is the default configuration if no env.ENVIRONMENT varaible is set.
        $default: {
            twitter: {
                provider: 'twitter',
                password: config.cookie.password,
                clientId: config.twitter.clientId,
                clientSecret: config.twitter.clientSecret,
                isSecure: false // Terrible idea but required if not using HTTPS
            },
            google: {
                provider: 'google',
                password: config.cookie.password,
                clientId: config.google.clientId,
                clientSecret: config.google.clientSecret,
                isSecure: false // Terrible idea but required if not using HTTPS
            }
        }
    }
});

var criteria = {
    env: process.env.ENVIRONMENT
};

exports.get = function(key) {
    return store.get(key, criteria);
};
