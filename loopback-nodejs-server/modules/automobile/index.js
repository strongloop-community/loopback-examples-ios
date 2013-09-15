/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var automobile = loopback.createModel('automobile', properties, config);
var applications = config.applications || [];

if (config['data-source']) {
  automobile.attachTo(require('../' + config['data-source']));
}

applications.forEach(function (name) {
  var app = require('../' + name);
  app.model(automobile);
});

module.exports = automobile;
