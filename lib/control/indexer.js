var AWS = require('aws-sdk');
var Artifact = require('../model/artifact');
var Collection = require('../model/collection');
var Path = require('path');
var URL = require('url');

var Package = require('../../package.json');

exports.attach = function(app) {
  var indexer = exports.indexer = new Indexer();

  app.get('/status', function(req, res, next) {
    res.json(indexer.status());
  });

  app.get('/universe', function(req, res, next) {
    if (!indexer.ready) return res.status(503).json({
      status: 503,
      error: 'The Universe has been indexed yet'
    });

    res.json(indexer.collection);
  });

  app.post('/update/:cookbook', function(req, res, next) {

  });

  indexer.start();
};

var Indexer = exports.Indexer = function() {
  this.bucket = Config.get('store:bucket');
  this.prefix = Config.get('store:prefix');
  this.location = URL.format({
    protocol: 'http',
    hostname: this.bucket,
    pathname: this.prefix
  });

  this.client = new AWS.S3();

  this.started = Date.now();
  this.ready = false;
  this.updating = false;

  this.collection = new Collection();
};

var M_METADATA = /.+\/\d\.\d\.\d\/metadata\.json$/;

function update() {
  var indexer = this;
  this.updating = true;

  // Build a queue
  this._updates = [];

  this.client.listObjects({
    Bucket: this.bucket,
    Prefix: this.prefix
  }, function(err, data) {
    if (err) return console.log(err); // TODO Handle this.

    // Find metadata files
    data.Contents.forEach(function(object) {
      if (M_METADATA.test(object.Key)) indexer._updates.push(object.Key);
    });

    // Start fetching metadata files
    reactor.call(indexer, function(err) {
      if (err) return console.log(err);
      indexer.updating = false;
      indexer.ready = true;
    });
  });
}

function reactor(callback) {
  var indexer = this;
  if (this._updates.length === 0) return callback();

  artifact.call(this, this._updates.shift(), function(err, artfact) {
    if (err) return callback(err);
    indexer.collection.add(artfact);
    reactor.call(indexer, callback);
  });
}

function artifact(key, callback) {
  var indexer = this;

  this.client.getObject({
    Bucket: this.bucket,
    Key: key
  }, function(err, data) {
    if (err) return callback(err);
    var meta;

    try {
      meta = JSON.parse(data.Body);
    } catch (e) {
      return callback(e);
    }

    callback(null, new Artifact(meta.name, meta.version, {
      dependencies: meta.dependencies,
      platforms: meta.platforms,
      location_path: indexer.location,
      download_url: URL.format({
        protocol: 'http',
        hostname: indexer.bucket,
        pathname: Path.join(Path.dirname(key), 'cookbook.tgz')
      })
    }));
  });
}

Indexer.prototype.status = function() {
  return {
    status: this.ready ? 'ok' : 'not-ok',
    mood: 'ಠ_ಠ',
    version: Package.version,
    cache_status: this.ready ? 'ok' : 'warming',
    uptime: (Date.now() - this.started) / 1000
  };
};

Indexer.prototype.start = function() {
  update.call(this);
};
