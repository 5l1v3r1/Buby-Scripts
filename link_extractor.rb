#!/usr/bin/env jruby
  

=begin  
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
=end


 #
 # This method checks, upon every request, if the request's URL is
 # ...in scope. If it is, burp will write the links to a links.txt file.
 #
 def $burp.evt_proxy_message(*param)
   msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
   prefix = is_https ? "https://" : "http://"
   rurl = "#{prefix}#{rhost}"  
   if (rurl) and $burp.isInScope(rurl)
     $burp.get_site_map(rurl).each do |item|
       file = ('links.txt')
         if item.respond_to?('url')
           File.open(file, "a") {|f| f.write("#{item.url}\n")}
         end
     end
   end
  
   return super(*param)
 end