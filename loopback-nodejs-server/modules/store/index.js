/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var store = loopback.Model.extend('store', properties, config);

if (config['data-source']) {
  store.attachTo(require('../' + config['data-source']));
}

module.exports = store;
