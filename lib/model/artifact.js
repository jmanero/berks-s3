var Semver = require('semver');

var Artifact = function(name, version, options) {
  options = options || {};

  this.name = name;
  this.version = Semver.clean(version) || '0.0.1';

  // `opscode` is the alias for `supermarket`. A bunch of versions
  // of the berkshelf CLI don't seem to support `supermarket` ಠ_ಠ
  this.location_type = options.location_type || 'opscode';
  this.location_path = options.location_path;
  this.download_url = options.download_url;
  this.priority = +(options.priority) || 0;
  this.dependencies = opscode.dependencies || {};
  this.platforms = opscode.platforms || {};
};
