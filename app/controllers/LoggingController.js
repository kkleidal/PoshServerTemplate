/* jshint node: true */
"use strict";

var logger = require('morgan');
var fs = require('fs');
var FileStreamRotator = require('file-stream-rotator');
var path = require('path');

module.exports = function(app) {
    var logDirectory = path.join(__dirname, '..', 'usage-logs');
    if (!fs.existsSync(logDirectory)) {
        fs.mkdirSync(logDirectory);
    }
    // create a rotating write stream
    var accessLogStream = FileStreamRotator.getStream({
        date_format: 'YYYYMMDD',
        filename: path.join(logDirectory, 'access-%DATE%.log'),
        frequency: 'daily',
        verbose: false
    });
    logger.token('sid', function(req) {
        if (req.session) return req.session.id || "-";
        else return "-";
    });
    logger.token('sseq', function(req) {
        if (req.session) return req.session.seq || 0;
        else return "-";
    });
    logger.token('suser', function(req) {
        if (req.session) {
            if (req.session.user) return req.session.user.FrameId + ":" + req.session.user.username;
        }
        return "-";
    });
    app.use(logger('":sid",":sseq",":suser","[:date[clf]]",":method",":url",":status",":res[content-length]",":referrer",":user-agent"', {
        stream: accessLogStream
    }));
    app.use(logger('dev'));
};