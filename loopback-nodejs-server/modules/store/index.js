/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var store = loopback.createModel('store', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  store.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(store);
});

module.exports = store;
