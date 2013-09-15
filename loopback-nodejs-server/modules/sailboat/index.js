/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var sailboat = loopback.createModel('sailboat', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  sailboat.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(sailboat);
});

module.exports = sailboat;
