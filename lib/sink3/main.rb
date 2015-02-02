require 'thor' 
require 'dotenv' 
require 'aws-sdk-v1' 

lib = File.expand_path('../..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sink3/path_crawler'

module Sink3 
  class Main < Thor
    option :delete, type: :boolean
    #
    # option :path, :required => true
    desc "Send file to S3", "Send files to S3 in write only mode"

    def send(*paths) 
      configure
      # overwrite hostname if configured
      Dotenv.overload('~/.sink3cfg')

      validate_env

      [paths].flatten.each do |path|
        path = Pathname.new(path)
        raise "specified path does not exist" unless path.exist?
        prefix = path.realdirpath.basename

        Sink3::PathCrawler.new(path, prefix).start
      end
    end

    private 

    def configure
      ENV['HOSTNAME'] = `hostname`.strip

      Sink3.configure do |config| 
        config.delete_after_upload = options[:delete]
      end
    end

    def validate_env 
      %w(REGION ACCESS_KEY SECRET_KEY).each do |key| 
        raise "missing #{key}" if ENV[key].to_s == ''
      end
    end
  end
end
