/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var boat = loopback.createModel('boat', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  boat.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(boat);
});

module.exports = boat;
