#!/usr/bin/env jruby

MY_SITE = 'www.example.com'

def $burp.evt_proxy_message(*param)
  msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
   
    if is_req == true
      if rhost == MY_SITE
        action[0] = 2
      end
    end
   super(*param)
 end