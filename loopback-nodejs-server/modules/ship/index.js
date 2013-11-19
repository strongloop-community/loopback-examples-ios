/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var ship = loopback.Model.extend('ship', properties, config);

if (config['data-source']) {
  ship.attachTo(require('../' + config['data-source']));
}

module.exports = ship;
