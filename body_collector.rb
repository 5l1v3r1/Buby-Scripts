#!/usr/bin/env jruby 
 
 #
 # This method does not modify anything, instead it goes
 # ...thru proxy messages and picks out requests which have
 # a "body" then writes them out to a file. 
 #
 def $burp.evt_http_message(*param)
   tool_name, is_request, message_info = param
   if is_request == true and message_info.respond_to?('req_body') 
       begin
         msg = message_info.req_body
         file = "results_#{Time.now}.txt"
         if !File.exists?(file)
         File.open(file, 'w') {|f| f.write(msg) }
         end
       end
     end
   return super(*param)
 end
