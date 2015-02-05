# Thor::S3Bookshelf
Manage cookbook artifacts in S3.

## Installation
Add `gem 'thor-s3bookshelf'` to your cookbook's Gemfile, and `require 'thor-s3bookshelf'` to your cookbook's Thorfile.

## Usage
Run `thor s3:help` for details

* `thor s3:release` Do all of the following in the right order:
* `thor s3:version:current` Write current version to /VERSION
* `thor s3:version:bump [major|minor|patch]` Increment version and write to /VERSION
* `thor s3:package` Generate artifacts for upload
* `thor s3:upload` Upload cookbook tarball and metadata to S3
* `thor s3:cleanup` Cleanup generated artifacts
