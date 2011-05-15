##
# The following code was used to determine what each object
# ...looks like.
##

PHIST_METHODS = [
  'host',
  'comment',
  'port',
  'status_code',
  'protocol',
  'request',
  'response',
  'comment',
  'url',
  'uri',
  'response_string',
  'response_headers',
  'response_body',
  'request_str',
  'request_body',
  'request_headers'
]

def prnt(*objs)
  strn, meth = objs  
  str = ''
  str << "\n#{strn}\n"
  str << '=' * strn.length + "\n\n"
  str << "#{meth}\n"
 puts str
end

def $burp.run
  proxy_hist = $burp.get_proxy_history
  
  if proxy_hist.length > 0
    proxy_hist.each do |itm|
      PHIST_METHODS.each {|meth| prnt("#{meth}", "#{itm.send(meth)}")}
    end
  end
end