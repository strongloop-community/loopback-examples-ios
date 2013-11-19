/*!
 * A CRUD-capable model.
 */
var loopback = require('loopback');
var properties = require('./properties');
var config = require('./config');
var product = loopback.Model.extend('product', properties, config);

if (config['data-source']) {
  product.attachTo(require('../' + config['data-source']));
}



//start custom methods
var tax = { federal:0.1, state: 0.22 };

// http://localhost:3000/products/taxInfo
product.currentTax = function(fn) {
	fn( null, tax );
}

loopback.remoteMethod(
  product.currentTax,
  {
    returns: {arg: 'currentTax', type: 'object'},
    http: {path: '/taxInfo', verb: 'get'}
  }
);


// http://localhost:3000/products/totalValuation
product.totalInventoryValuation = function(fn) {
	product.find(function(err, products) {
		
		var totalValuation = { inventoryValuation : 0 };
		for (var i = 0; i < products.length; i++) {
				if(typeof products[i].price != 'undefined' && typeof products[i].inventory != 'undefined' )
					totalValuation.inventoryValuation += products[i].price * products[i].inventory;
		}//end for
		
    fn(null, totalValuation);
  });
}//end addTax

loopback.remoteMethod(
  product.totalInventoryValuation,
  {
    returns: {arg: 'totalInventoryValuation', type: 'object'},
    http: {path: '/totalValuation', verb: 'get'}
  }
);

//end custom methods


module.exports = product;
