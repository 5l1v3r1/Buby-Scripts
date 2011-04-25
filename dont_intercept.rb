#!/usr/bin/env jruby


#
# Not much too this script, just an example of taking a target site (MY_SITE) and choosing
# ...to NOT intercept the requests for it. More or less an example script really.
#


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