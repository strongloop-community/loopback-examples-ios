/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var car = loopback.Model.extend('car', properties, config);

if (config['data-source']) {
  car.attachTo(require('../' + config['data-source']));
}

module.exports = car;
