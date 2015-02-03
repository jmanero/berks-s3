var Config = global.Config = require('nconf');
var Path = require('path');

Config.file('site', Path.resolve(__dirname, '../config/site.json'));
Config.defaults({
  service: {
    domain: {
      protocol: 'https',
      hostname: 'localhost',
      port: 8443
    },
    listen: './server.sock'
  }
});
