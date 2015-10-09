##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'

class Metasploit3 < Msf::Auxiliary

  include Msf::Exploit::Remote::Tcp
  include Msf::Auxiliary::Scanner
  include Msf::Auxiliary::Report

  def initialize
    super(
      'Name'        => 'POP3 Banner Grabber',
      'Description' => 'POP3 Banner Grabber',
      'Author'      => 'hdm',
      'License'     => MSF_LICENSE
    )
    register_options([
      Opt::RPORT(110)
    ], self.class)
  end

  def run_host(ip)
    begin
      res = connect
      banner = sock.get_once(-1, 30)
      banner_sanitized = Rex::Text.to_hex_ascii(banner.to_s)
      print_status("#{ip}:#{rport} POP3 #{banner_sanitized}")
      report_service(:host => rhost, :port => rport, :name => "pop3", :info => banner)
    rescue ::Rex::ConnectionError
    rescue ::EOFError
      print_error('The service failed to respond with a banner')
    rescue ::Exception => e
      print_error("#{rhost}:#{rport} #{e} #{e.backtrace}")
    end
  end

end
