/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var customer = loopback.Model.extend('customer', properties, config);

if (config['data-source']) {
  customer.attachTo(require('../' + config['data-source']));
}

module.exports = customer;
