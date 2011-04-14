#!/usr/bin/env ruby

  def $burp.evt_proxy_message(*param)
  msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
   file = ('cookiez.txt')
   prefix = nil
   if is_https == true
     prefix = 'https'
   else
     prefix = 'http'     
   end
   #rurl = "#{prefix}://#{rhost}:#{rport}"
   if is_req == false
    spmsg = message.split("\n\n")
    short_msg = "#{spmsg}"
    mitem = short_msg.match(/^Set-Cookie:.+$/)
    #  if $burp.in_scope?(rurl)  
        if !mitem.nil?
          File.open(file, "a") {|f| f.write("#{mitem}")}
        end
     # end
   end   
    super(*param)
  end
