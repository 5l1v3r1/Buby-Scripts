# Example doActiveScan, doPassiveScan, isInScope
# This is an example script, in attempt to teach Buby   


@@msg = nil

def $burp.evt_proxy_message(*param) 
  msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param 
  pre = is_https ? 'https' : 'http'
  pre_bool = is_https ? true : false
  uri = "#{pre}://#{rhost}:#{rport}#{url}"  
  
  if is_req == true
     @@msg = message
  end
    
  if $burp.isInScope(uri)
    if is_req == true
     # In latest 3.0 version of Buby I noticed a discrepancy with not adding a 5th argument (nil) to active scans
      $burp.do_active_scan(rhost, rport, pre_bool, message, nil)
      req = message
    else
      $burp.do_passive_scan(rhost, rport, pre_bool, @@msg, message)
    end
  end
   super(*param)      
end
