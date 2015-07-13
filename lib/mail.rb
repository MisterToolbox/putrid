#!/usr/bin/env ruby

require 'net/smtp'

module Putrid
	class Mail
		attr_accessor #attrs_here

		def initialize(diff_text)
			@diff_text = diff_text
			@smtp_from = "putrid@example.com"
			@smtp_to = "me@example.com"
      @smtp_server = "mail.example.com"
      @smtp_port = 25

			@message = <<MESSAGE_END
From: putrid <#{@smtp_from}>
To: Putrid recipients <#{@smtp_to}>
Subject: Putrid report - #{Time.now.strftime("%Y-%m-%d %H:%M")}

#{@diff_text}
MESSAGE_END
		end

		def send_email
			Net::SMTP.start(@smtp_server, @smtp_port) { |smtp| smtp.send_message(@message, @smtp_from, @smtp_to) }
		end

	end
end
