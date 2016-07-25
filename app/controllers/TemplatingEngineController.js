/* jshint node: true */
"use strict";

var exphbs = require('express-handlebars');
var Handlebars = require('handlebars');
require('datejs');

var hbs = exphbs.create({
    helpers: {
        date: function(object) {
            var date = Date.parse(object);
            return date.toString("MMMM dS");
        },
        json: function(object) {
            return new Handlebars.SafeString(JSON.stringify(object));
        },
        capitalizeWords: function(object) {
            if (!object || !object.split) {
                return "";
            }
            return object.split(" ").map(function(word) {
                if (word.length > 0) {
                    return word.charAt(0).toUpperCase() + word.slice(1);
                } else {
                    return word;
                }
            }).join(" ");
        }
    },
    defaultLayout: 'main'
});

module.exports = function(app) {
    app.engine('handlebars', hbs.engine);
    app.set('view engine', 'handlebars');
};