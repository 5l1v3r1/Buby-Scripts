#!/usr/bin/env jruby
require 'zlib'


# There are two methods. One is turned off by prefixing with =begin and appending =end. If you'd like to turn a method on, 
# ...omit the =begin and =end tags. 

=begin
 #
 # This analyzes messages from the proxy and inflates them
 # ...if they are a request and contain a body
 #
 def $burp.evt_http_message(*param)
   tool_name, is_request, message_info = param
     if is_request == true and message_info.respond_to?('req_body')
       msg = message_info.req_body
       val = msg.to_s.length
         if val > 0
           zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
           buf = zstream.inflate("#{msg}")
           zstream.finish
           zstream.close
           puts buf
         end # end of second if
     end # end of first if
    return super(*param) 
 end
=end

    

  #
  # Unlike $burp.evt_http_message this is a desctructive
  # ...method which extracts the body and inflates the zlib compressed data
  # ...and modifies the request body before reaching Burp. This is not difficult to change
  # ...for instance, if you'd like to modify responses, change is_req == true to 
  # ...is_req == false. Also, you can choose http_meth == "GET" instead of "POST" for requests.
  # Botomline, you will need to modify this script for your benefit.
  #
  def $burp.evt_proxy_message(*param)
    msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
    str_msg = message.dup
      if is_req == true and http_meth == "POST" and str_msg.match(/s=/)
        split_msg = str_msg.split(' ')
        true_index = nil  
          split_msg.each_with_index do |item, idx|
            if item.match(/Content-Length:/)
              true_index = idx + 1
            end
          end
        if !true_index.nil? and true_index != 0 
          begin
            eval("split_msg.slice!(0..#{true_index})")
            zlib_str = split_msg.to_s
            zstream = Zlib::Inflate.new
            inf = zstream.inflate("#{zlib_str}")
            zstream.finish
            zstream.close
            message.gsub!("#{zlib_str}", "#{inf}")
          rescue => $!
              puts("We've received the following error: #{$!}")
          end
        end
      end
     return super(*param)
  end

#