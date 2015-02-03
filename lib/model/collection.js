var Collection = module.exports = function() {
  this.artifacts = {};
};

Collection.prototype.add = function(artifact) {
  if (!this.artifacts.hasOwnProperty(artifact.name))
    this.artifacts[artifact.name] = {};
  this.artifacts[artifact.name][artifact.version] = artifact;
};

Collection.prototype.toJSON = function() {
 return this.artifacts;
};
