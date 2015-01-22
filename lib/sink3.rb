require "sink3/version"
require 'sink3/main'
require 'sink3/path_crawler'

module Sink3
  # Your code goes here...
  class << self 
    attr_accessor :config 
  end

  def self.configure 
    self.config ||= Configuration.new 
    yield config
  end

  class Configuration 
    attr_accessor :delete_after_upload

    def delete_after_upload
      !!@delete_after_upload
    end
    alias_method :delete_after_upload?, :delete_after_upload

  end
end
