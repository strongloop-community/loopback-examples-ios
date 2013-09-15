/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var product = loopback.createModel('product', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  product.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(product);
});

module.exports = product;
