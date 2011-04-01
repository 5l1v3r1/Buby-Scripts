#!/usr/bin/env jruby
require 'zlib'

class MyClass < Buby
 def initialize
     super
 end


  def $burp.evt_http_message(*param)
  tool_name, is_request, message_info = param
  
    if is_request == true and message_info.respond_to?('req_body')
     
      
      msg = message_info.req_body
      file = '/Users/cktricky/tools/results.txt'
       File.open(file, 'w') {|f| f.write(msg) }
      $burp.close
     
    end
    return super(*param)
  end

=begin

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


    


  def $burp.evt_proxy_message_raw(*param)
     msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param

      str_msg = String.from_java_bytes(message)
     
      if is_req == true and http_meth == "POST" and str_msg.match(/s=/)
      
     # split_msg = str_msg.split('\r\n\r\n')
      #msg = (split_msg[1])
      puts str_msg
     
      zstream = Zlib::Inflate.new
      buf = zstream.inflate("#{msg}")
      zstream.finish
      zstream.close
      puts buf
      end
      
      return super(*param)
      end
      


      zstream = Zlib::Inflate.new
      buf = zstream.inflate(str_msg)
      zstream.finish
      zstream.close
      puts buf



    def $burp.evt_proxy_message(*param)
        msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param

        if is_req == true and message.match(/s=/)       
        puts message
        # zstream = Zlib::Inflate.new
        # buf = zstream.inflate("#{msg}")
        # zstream.finish
        # zstream.close
        # puts buf
        end
      
      return super(*param)   
    end
=end

  

end