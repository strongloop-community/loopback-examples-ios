/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var sailboat = loopback.Model.extend('sailboat', properties, config);

if (config['data-source']) {
  sailboat.attachTo(require('../' + config['data-source']));
}

module.exports = sailboat;
