/* jshint node: true */
"use strict";

var RequestController = {};

RequestController.end = function(req, res, status, response, template) {
    var output = {
        "status": status,
        "body": response
    };
    if (status >= 400) {
        template = template || "error";
    }
    if (req.accepts("html") && template) {
        return res.status(output.status).render(template, output);
    } else {
        return res.status(output.status).end(JSON.stringify(output));
    }
};

RequestController.error = function(req, res, error) {
    RequestController.end(req, res, error.status || 500, {
        message: error.message || "Internal Server Error"
    }, "error");
};

Object.freeze(RequestController);
module.exports = RequestController;