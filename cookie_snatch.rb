#!/usr/bin/env ruby

  
  # Method reviews the request, then the cookie which has been set
  # ...is logged to cookiez.txt in the directory your running the
  # ...script from.
  
  def $burp.evt_proxy_message(*param)
  msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
    prefix = is_https ? "https://" : "http://"
   # Uncomment commented items below item to check if the URL you are requesting
   # ...is in scope. If so, only THEN will the cookie be logged.
   #rurl = "#{prefix}://#{rhost}:#{rport}"
   if is_req == false
    spmsg = message.split("\n\n")
    short_msg = "#{spmsg}"
    mitem = short_msg.match(/^Set-Cookie:.+$/) 
    #  if $burp.in_scope?(rurl)  
        if !mitem.nil?
          File.open(file, "a") {|f| f.write("#{mitem}")} #Change the "a" to "w" if you'd like to overwrite with each set-cookie
        end
     # end
   end   
    super(*param)
  end
