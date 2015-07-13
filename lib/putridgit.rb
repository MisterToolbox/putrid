#!/usr/bin/env ruby

require 'rubygems'
require 'git'

require_relative 'logging.rb'

module Putrid
  class PutridGit
    include Logging
    attr_accessor :log_path, :last_commits, :git_object
    
    def initialize(log_path)
      @last_commits = []
      @log_path = log_path
      @git_object = Git.open(@log_path, :log => logger)
    end
    
    def add
      @git_object.add
    end
    
    def atomic_operation
      add
      commit
      push
      log
      diff
    end
    
    def commit
      @git_object.commit("Putrid Logs - #{Time.now.strftime("%Y-%m-%d_%H:%M")}")
    end
    
    def diff
      @git_object = nil
      git_log = Logger.new("/tmp/putrid.diff")
      git_log.formatter = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
      @git_object = Git.open(@log_path, :log => git_log)
      @git_object.diff(@last_commits[-2], @last_commits[-1])
    end
    
    def log
      git_object.log(2).each do |com|
        @last_commits.push(com.name)
      end
    end
    
    def push()
      @git_object.push
    end

  end
end