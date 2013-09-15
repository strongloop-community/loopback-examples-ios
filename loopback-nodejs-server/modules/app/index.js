/*!
 * The Application module is responsible for attaching other modules to an Loopback application.
 */
var loopback = require('loopback');
var config = require('./config');
var app = loopback();
var path = require('path');
var transports = config.transports || [];
var started = new Date();

/**
 * If we've defined transports for remoting, attach those to the Application.
 */
transports.forEach(function (name) {
  var fn = loopback[name];

  if (typeof fn === 'function') {
    app.use(fn.call(loopback));
  } else {
    console.error('Invalid transport: %s', name);
  }
});

/**
 * Start the server.
 */
var server = app.listen(config.port || 3000, function (err) {
  if (err) {
    console.error('Failed to start loopback-project.');
    console.error(err.stack || err.message || err);
    process.exit(1);
  }

  var info = server.address();
  var base = 'http://' + info.address + ':' + info.port;
	
  console.log('loopback-project running at %s.', base);
  console.log('To see the available routes, open %s/routes', base);
  console.log('To see the API explorer, open %s/explorer', base);
});

/**
 * Provide a basic status report as `GET /`.
 */

app.get('/serverstatus', function getStatus(req, res, next) {
  res.send({
    started: started,
    uptime: (Date.now() - Number(started)) / 1000
  });
});

// Add static files
app.use(loopback.static(path.join(__dirname, 'public')));

//load the boat locations from a json file
/*
var shiplocations = require('./data/shiplocations.json');
var i = 1;
loopback.memory().autoupdate(function () {
	shiplocations.forEach(function (obj) {
			var instance = { id: ++i, name: obj[6] , geo:{ lat: obj[1], lng: obj[2]} , MMSI:obj[0], SPEED:obj[3], COURSE:obj[4], STATUS:obj[5], TIMESTAMP:obj[5], SHIPTYPE:obj[7], FLAG:obj[10] };
			//LENGTH="90" WIDTH="14" DRAUGHT="50" YEAR_BUILT="2012
	    importer.task(BoatModel, 'create', instance);
	});//end shipLocations
});
*/

/*!
 * Export `app` for use in other modules.
 */
module.exports = app;
