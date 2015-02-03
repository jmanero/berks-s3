var Package = require('auto-package');

Package.name('berks-s3');
Package.version_file();
Package.author('John Manero', 'john.manero@gmail.com');
Package.description('Berkshelf API for an S3 store');

Package.depends('aws-sdk', '2.x');
Package.depends('express', '4.x');
Package.depends('nconf', '0.7.x');
Package.depends('semver', '4.x');

Package.github_repo('jmanero/berks-s3');

Package.keyword('berkshelf');
Package.keyword('berks-api');
Package.license('MIT');
