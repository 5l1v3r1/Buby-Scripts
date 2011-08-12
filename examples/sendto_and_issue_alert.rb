# Example issueAlert, sendToIntruder, sendToRepeater, sendToSpider
# This is an example script, in attempt to teach Buby


# This is just an array which contains params we want
# to send over to intruder
FUZZ_PARAMS = [
  'uid',
  'profileId',
  'user_id',
  'profile_id',
  'account_id',
  'Price',
  'useraccountid',
  'area'
]


#
# Request Method extraction (Looking for GET or POST)
#
def req_meth(obj)
  http_meth = ''
  if obj.respond_to?('request_headers')
    http_meth = obj.request_headers[0].to_s[0..3]
  end
  return http_meth
end


#
# Lets extract any strings that match
# ...our manual fuzz array
#
def extract_str(*objs)
  http_meth, req, count = objs
  bparam = {}
  if http_meth == 'POST'   
    bparam_split_amp = req.request_body.split('&')
    bparam_split_amp.to_s.split('=')
    bparam_split_amp.each do |itm|
      spl = itm.split('=')
      bparam["#{spl[0]}"] = "#{spl[1]}"
    end
   elsif http_meth == 'GET '
    path = req.url.to_s.match(/^.*?:\/\/.*?(\/.*)$/)
    rpath = "#{path[1]}".match(/^[^?#]+\?([^#]+)/)
    if not rpath.nil?
      bparam_split_amp = "#{rpath[1]}".split('&')
      bparam_split_amp.to_s.split('=')
      bparam_split_amp.each do |itm|
        spl = itm.split('=')
        bparam["#{spl[0]}"] = "#{spl[1]}"
      end
    
    end
   end
   
   proto = req.protocol == 'https' ? true : false
   
   FUZZ_PARAMS.each do |fuzzp|
     if bparam.has_key?(fuzzp) and $burp.isInScope(req.url) == true
       sendToIntruder(req.host, req.port, proto, req.request_string)
       sendToRepeater(req.host, req.port, proto, req.request_string, "#{fuzzp}-#{count}")
       issueAlert("We've sent #{fuzzp}-#{count} to intruder")
       issueAlert("We've sent #{fuzzp}-#{count} to repeater")
     end
   end
end


#
# Runs this whole shebangabang
#
def $burp.run
  proxy_hist = $burp.get_proxy_history
  if proxy_hist.length > 0
    proxy_hist.each_with_index do |obj, idx|
      cnt = idx
      if obj.request
        hmeth = req_meth(obj)
        extract_str(hmeth, obj, cnt)
      end
    end     
  end
end
