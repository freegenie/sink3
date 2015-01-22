require 'pathname'

module Sink3
  class PathCrawler 
    def initialize(path, prefix, parent=nil)
      @parent = parent
      @prefix = prefix

      if @parent.nil? 
        @path = Pathname.new(path)
      else
        @path = parent.join(path)
      end

      # If path is '.' then just skip the prefix
      if path == prefix 
        @prefix = nil 
      end
    end

    def start
      raise "Path does not exist" unless @path.exist? 
      if @path.directory? 
        @path.opendir.each do |file| 
          next if file.start_with? '.'
          PathCrawler.new(file, @prefix, @path).start
        end
      else
        send_to_remote
      end
    end

    private 

    def s3
      @s3 ||= AWS::S3.new(
        :access_key_id => ENV['ACCESS_KEY'],
        :secret_access_key => ENV['SECRET_KEY'], 
        :region => ENV['REGION']
      )
    end

    def bucket 
      s3.buckets[ENV['BUCKET']]
    end

    def send_to_remote
      remote_path = "#{ENV['HOSTNAME'].strip}/#{formatted_date}/#{prefix_and_path}"
      remote_file = bucket.objects[remote_path]
      remote_file.write(@path)

      if Sink3.config.delete_after_upload? 
        FileUtils.rm @path
      end
    end

    def formatted_date
      Time.now.strftime "%Y-%m-%d"
    end

    def prefix_and_path
      if @prefix.nil? 
        "#{@path}" 
      else
        "#{@prefix}/#{@path}"
      end
    end

  end
end
