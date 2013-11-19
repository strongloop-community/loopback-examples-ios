/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var automobile = loopback.Model.extend('automobile', properties, config);

if (config['data-source']) {
  automobile.attachTo(require('../' + config['data-source']));
}

module.exports = automobile;
