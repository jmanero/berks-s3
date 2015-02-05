require 'thor'

class Thor
  module S3Bookshelf
    ##
    # S3 Release tasks
    ##
    class Artifact
      attr_reader :name
      attr_reader :path
      attr_reader :content_type
      attr_reader :_generator

      def initialize(name, options = {}, &generator)
        tmp_dir = options[:tmp_dir] || File.join(Tasks.source_root, '.bookshelf/tmp')

        @name = name
        @path = options[:path] || File.join(tmp_dir, name)
        @content_type = options[:content_type] || 'application/octet-stream'

        @_generator = generator
      end

      def cleanup
        File.unlink(@path)
      rescue Error::ENOENT
      end
    end
  end
end
