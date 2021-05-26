require 'thor' 
require 'dotenv' 
require 'aws-sdk-v1' 

lib = File.expand_path('../..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sink3/path_crawler'

module Sink3 
  class Main < Thor
    #
    # option :path, :required => true
    desc "send", "Send files to S3 in write only mode"

    option :delete, type: :boolean, desc: "delete origin file on succesful send"
    option :skip_overwrite, type: :boolean, desc: "skip sending file if exists" 
    option :verbose, type: :boolean, desc: "verbose" 
    option :skip_date_partition, type: :boolean, desc: "remove YYYY-MM-DD remote prefix" 
    option :skip_full_path, type: :boolean, desc: "don't archive file with full path prefix" 

    def send(*paths) 
      configure
      # overwrite hostname if configured
      Dotenv.overload('~/.sink3cfg')

      validate_env

      prefix = nil 
      [paths].flatten.each do |path|
        path = Pathname.new(path)
        raise "specified path does not exist" unless path.exist?
	
	if path.relative? || Sink3.config.skip_full_path
          prefix = nil 
	else 
          path = path.realdirpath
	end
        puts "prefix is #{prefix}" if Sink3.config.verbose
        Sink3::PathCrawler.new(path, prefix).start
      end
    end

    private 

    def configure
      ENV['HOSTNAME'] = `hostname`.strip

      Sink3.configure do |config| 
        config.delete_after_upload = options[:delete]
        config.skip_overwrite = options[:skip_overwrite]
        config.verbose = options[:verbose]
        config.skip_date_partition = options[:skip_date_partition]
        config.skip_full_path = options[:skip_full_path]
      end
    end

    def validate_env 
      %w(REGION ACCESS_KEY SECRET_KEY).each do |key| 
        raise "missing #{key}" if ENV[key].to_s == ''
      end
    end
  end
end
