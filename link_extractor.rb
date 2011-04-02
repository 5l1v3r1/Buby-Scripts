#!/usr/bin/env jruby
  
  
  #
  # Basic method to demonstrate extracting links from a site map
  # ...this example uses the site http://www.cnn.com as the URL we'd
  # ...like to retrieve links from.
  #
  def $burp.evt_http_message(*param)
    tool_name, is_request, message_info = param
      $burp.get_site_map('http://www.cnn.com').each do |item|
        file = ('links.txt')
          if item.respond_to?('url')
            File.open(file, "a") {|f| f.write("#{item.url}\n")}
          end
      end
    return super(*param)
  end
 