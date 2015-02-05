class Thor
  module S3Bookshelf
    VERSION = IO.read(File.expand_path(
      '../../../../VERSION', __FILE__)) rescue '0.0.1'
    DESCRIPTION = IO.read(File.expand_path(
      '../../../../README.md', __FILE__)) rescue 'Unable to read README.md'
  end
end
