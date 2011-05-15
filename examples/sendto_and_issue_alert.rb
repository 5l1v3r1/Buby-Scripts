# Example issueAlert, sendToIntruder, sendToRepeater, sendToSpider
# This is an example script, in attempt to teach Buby

#sendToRepeater(host, port, https, req, tab = nil)

#sendToSpider(url)



# This is just an array which contains params we want
# to send over to intruder
FUZZ_PARAMS = [
  'uid',
  'profileId',
  'user_id',
  'profile_id',
  'account_id',
  'Price'
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
  http_meth, req = objs
  return unless http_meth == 'POST'
    bparam = {}
    bparam_split_amp = req.request_body.split('&')
    bparam_split_amp.to_s.split('=')
    bparam_split_amp.each do |itm|
      spl = itm.split('=')
      bparam["#{spl[0]}"] = "#{spl[1]}"
    end
   
   proto = req.protocol == 'https' ? true : false
   
   FUZZ_PARAMS.each do |fuzzp|
     if bparam.has_key?(fuzzp)
       sendToIntruder(req.host, req.port, proto, req.request_string)
       sendToRepeater(req.host, req.port, proto, req.request_string, "#{fuzzp}")
       issueAlert("We've sent #{fuzzp} to intruder")
       issueAlert("We've sent #{fuzzp} to repeater at")
     end
   end
end


#
# Runs this whole shebangabang
#
def $burp.run
  proxy_hist = $burp.get_proxy_history
  
  if proxy_hist.length > 0
    proxy_hist.each do |obj|
      if obj.request
        hmeth = req_meth(obj)
        extract_str(hmeth, obj)
      end
    end     
  end
end
