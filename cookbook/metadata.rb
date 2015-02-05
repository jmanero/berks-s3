name 'berks-s3'
maintainer 'John Manero'
maintainer_email 'john.manero@gmail.com'
description 'Berkshelf API for S3'

license IO.read(File.absolute_path('../../LICENSE', __FILE__)) rescue 'MIT'
long_description IO.read(File.absolute_path('../../README.md', __FILE__)) rescue ''
version IO.read(File.absolute_path('../../VERSION', __FILE__)) rescue '0.0.1'

depends 'apt'
