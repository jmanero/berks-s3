var Express = require('express');
var FS = require('fs');
var HTTP = require('http');

require('../lib/config');

var app = Express();
var server = HTTP.createServer(app);

require('../lib/control/indexer').attach(app);

try { // Try to clean up existing file handle
  if (FS.existsSync(Config.get('service:listen'))) {
    console.log('Trying to remove existing socket file ' + Config.get('service:listen'));
    FS.unlinkSync(Config.get('service:listen'));
  }
} catch(e) {
  console.log('Error cleaning up socket file');
}

server.listen(Config.get('service:listen'), function() {
  console.log('Listening for requests on ' + Config.get('service:listen'));
});
