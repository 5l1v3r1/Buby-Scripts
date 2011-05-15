# Example makeHttpRequest, sendToSpider
# This is an example script, in attempt to teach Buby

# makeHttpRequest(host, port, pre, request_string)
# host  = The hostname of the remote HTTP server.
# port  = The port of the remote HTTP server.
# https = Flags whether the protocol is HTTPS or HTTP.
# req   = The full HTTP request. (String or Java bytes[])

def get_req(host, port, path)
  str = ''
  str << "GET #{path} HTTP/1.1\n"
  str << "Host: #{host}:#{port}\n"
  str << "User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.16) Gecko/20110319 Firefox/3.6.16\n"
  str << "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\n"
  str << "Accept-Language: en-us,en;q=0.5\n"
  str << "Accept-Encoding: gzip,deflate\n"
  str << "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\n"
  str << "Keep-Alive: 115\n"
  str << "Proxy-Connection: keep-alive\n\n"
  return str
end

def $burp.get(url)
  if in_scope?(url) == false
    sendToSpider(url)
  end
  path_match = url.match(/^.*?:\/\/.*?(\/.*)$/)
  path = path_match
  prefix = url.match(/(http:\/\/|https:\/\/)/)
  uri = url.gsub("#{prefix}", '')  
  pre_sub_host = uri.match(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/) || uri
  presub_port =  uri.match(/:+\d{1,5}/) || 80
  port = presub_port.to_s.gsub(':', '').to_i  
  pre = "#{prefix}" == "https://" ? true : false   
  rpath = path.kind_of?(MatchData) ? path[1].to_s : '/'
  host = uri.to_s.gsub("#{presub_port}", '').gsub(rpath, '')
  req_str = get_req(host, port, rpath)
  res = makeHttpRequest(host, port, pre, req_str)
  puts res
end
