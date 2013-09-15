/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var customer = loopback.createModel('customer', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  customer.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(customer);
});

module.exports = customer;
