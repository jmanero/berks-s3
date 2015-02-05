require 'aws-sdk'
require 'buff/ignore'
require 'chef/cookbook/metadata'
require 'json'
require 'thor'
require 'thor-scmversion'

require_relative './s3bookshelf/artifact'

## Configuration
def bucket(name)
  Thor::S3Bookshelf::Tasks.config(:bucket, name)
end

def bucket_prefix(name)
  Thor::S3Bookshelf::Tasks.config(:bucket_prefix, name)
end

def cookbook(path)
  Thor::S3Bookshelf::Tasks.config(:cookbook, path)
end

class Thor
  module S3Bookshelf
    ##
    # S3 Release tasks
    ##
    class Tasks < Thor
      include Thor::Actions
      namespace 's3'

      class << self
        def source_root
          @source_root ||= begin
            path = Dir.pwd
            until File.exist?(File.join(path, 'Thorfile'))
              fail Errno::ENOENT, 'Unable to locate Thorfile in current path' if path == '/'
              path = File.dirname(path)
            end
            path
          end
        end

        def config(param, value = nil)
          ## Defaults
          @config ||= {
            :bucket => 'DEFAULT',
            :bucket_prefix => '',
            :cookbook => '.'
          }

          @config[param] = value unless value.nil?
          @config[param]
        end
      end

      no_commands do
        ## Get cookbook path. Defaults to source_root
        def cookbook
          File.absolute_path(Tasks.config(:cookbook), Tasks.source_root)
        end

        ## Load chefignore
        def chefignore
          @chefignore ||= Buff::Ignore::IgnoreFile.new(File.join(cookbook, 'chefignore')) rescue nil
        end

        ## Load cookbook metadata
        def metadata
          @metadata ||= begin
            metadata = Chef::Cookbook::Metadata.new
            metadata.from_file(File.join(cookbook, 'metadata.rb'))

            metadata ## Retrun populated metadata object
          end
        end

        def artifacts
          ## Default cookbook artifacts
          @artifacts ||= [
            Artifact.new('metadata.json',
                         :path => File.join(cookbook, 'metadata.json'),
                         :content_type => 'application.json') do |artifact|
              create_file artifact.path, JSON.pretty_generate(metadata.to_hash)
            end,
            Artifact.new('cookbook.tgz',
                         :content_type => 'application/x-gzip') do |artifact|
              inside cookbook do
                files = `git ls-files`.split("\n")

                chefignore.apply!(files) unless chefignore.nil?
                files << 'metadata.json' unless files.include?('metadata.json')

                run "tar -czf #{artifact.path} #{files.join(' ')}"
              end
            end
          ]
        end

        def artifact(name, options = {}, &generator)
          artifacts << Artifact.new(name, options, &generator)
        end

        def bucket
          fail ArgumentError, 'Set an S3 bucket!' if Tasks.config(:bucket) == 'DEFAULT'
          @bucket ||= AWS::S3.new.buckets[Tasks.config(:bucket)]
        end
      end

      desc 'release [major|minor|Patch|prerelease [PRERELEASE_TYPE]]',
           'Increment version, package, and upload cookbook'
      def release(bump = 'patch', prerelease = nil)
        invoke :package
        invoke :upload
        invoke :cleanup
      end

      desc 'package', 'Generate releasable artifacts'
      def package(bump = nil, prerelease = nil)
        empty_directory '.bookshelf/tmp'
        invoke 'version:bump', bump, prerelease unless bump.nil?
        invoke 'version:current', []

        artifacts.each do |artifact|
          say_status :artifact, artifact.name
          instance_exec(artifact, &artifact._generator)
        end
      end

      desc 'upload', 'Upload packages source and metadata'
      def upload(*_)
        artifacts.each do |artifact|
          say_status :upload, artifact.name

          bucket.objects[File.join(
            Tasks.config(:bucket_prefix),
            metadata.name,
            metadata.version,
            artifact.name)].write(
              :file => artifact.path,
              :content_type => artifact.content_type)
        end
      end

      desc 'cleanup', 'Remove generated local files'
      def cleanup(*_)
        artifacts.each(&:cleanup)
      end
    end
  end
end
