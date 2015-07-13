#!/usr/bin/env ruby

require 'logger'

module Logging
  @@out = nil

  def self.out
    @@out
  end

  def self.out=(logFile)
    @@out = logFile
  end

  def logger
    Logging.logger
  end

  def self.logger
    unless @logger
      @logger = Logger.new(@@out)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end
    @logger
  end
  
  def self.logger=(obj)
    @logger = obj
  end
  
end
