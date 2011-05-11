# Example evt_http_message
# This is an example script, in attempt to teach Buby

def $burp.evt_http_message(*param)
   tool_name, is_request, message_info = param
     if tool_name == 'spider' and is_request == false
      if message_info.statusCode == 200
         puts "Yo, we received a 200 FTW!"
      end
     end
  super(*param) 
end

