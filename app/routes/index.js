/* jshint node: true */
"use strict";

var express = require('express');
var router = express.Router();

var RequestController = require('../controllers/RequestController');

router.use(function(req, res, next) {
    req.session.seq = (req.session.seq || 0) + 1;
    req.session.save(next);
});

/* GET home page. */
router.get('/', function(req, res, next) {
    return RequestController.end(req, res, 200, {}, 'index');
});

module.exports = router;