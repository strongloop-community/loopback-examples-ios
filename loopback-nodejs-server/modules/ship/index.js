/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var ship = loopback.createModel('ship', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  ship.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(ship);
});

module.exports = ship;
