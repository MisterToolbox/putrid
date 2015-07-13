#!/usr/bin/env ruby

require 'rubygems'
require 'highline/import'
require 'net/ssh/telnet'
require 'net/telnet'

require_relative 'logging'

module Putrid
  class CiscoConnect
	  include Logging
	  attr_accessor :ip, :username, :password, :platform, :tn

	  def initialize(ip, username = nil, password = nil)
	    @ip, @username, @password = ip, username, password

		  begin
			  @tn = Net::SSH::Telnet.new("Host" => @ip, "Username" => @username, "Password" => @password, "Timeout" => 5, "Waittime" => 0.1, "Prompt" => /[#>:]/n) do |resp|
          if resp.include?("Nexus")
            @platform = "nexus"
          elsif resp.include?("Unauthorized")
            @platform = "asa"
          else
            @platform = "catalyst"
          end
          print "==> #{resp}"
        end
	    	logger.info "Connected via SSH to #{@ip}"
      rescue Errno::ENETUNREACH, Timeout::Error
        logger.error "#{@ip} unreachable - skipping collection"
        raise "#{@ip} unreachable - skipping collection"
		  rescue Errno::ECONNREFUSED, Net::SSH::Disconnect
			  logger.warn "SSH Connection Refused - connecting via Telnet to #{@ip}"
	    	@tn = Net::Telnet::new("Host" => @ip, "Timeout" => 10, "Waittime" => 0.1, "Prompt" => /[#>:]/n) { |resp| print "==> " + resp }
	    	logger.info "Connected via Telnet to #{@ip}"
		    @tn.cmd(@username) { |c| print c }
		    @tn.cmd(@password) { |c| print c }
		  end

		  set_terminal_length
	  end

	  def conn_close
	    @tn.cmd('exit') { |c| print c }
		  logger.debug "Closing connection to #{@ip}"
	  end

	  def conn_command(comm)
	    logger.debug @tn.cmd(comm) { |c| print c }
    end

	  def conn_confmode
	    logger.warn @tn.cmd('conf t') { |c| print c }
	  end

	  def set_terminal_length(length=0)
      if @platform == 'asa'
        logger.debug @tn.cmd('terminal pager ' + length.to_s) { |c| print c }
      else
		    logger.debug @tn.cmd('terminal length ' + length.to_s) { |c| print c }
      end
	  end

	  def vlan_change(vlanID, interface)
		  conn_select_interface(interface)
		  logger.debug @tn.cmd('switchport access vlan ' + vlandID)
	  end
  end
end
