#!/usr/bin/env ruby

module Putrid
  class ConfigFiles
	  attr_accessor :configFile

	  def initialize(configFile)
	    @configFile = configFile
	    File.open(@configFile, 'r') do |infile|
	      while line = infile.gets
	        yield line.chomp
	      end
	    end
	  end
  end
end
