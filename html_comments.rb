#!/usr/bin/env jruby 

#
#
#
def $burp.process_html_comments(*param)
  url, rhost, rport, prefix, message = param
  str_msg = message.dup
  file = "comments_#{rhost}"
  if (message)
    split_msg = str_msg.split(' ')
    true_index = nil  
      split_msg.each_with_index do |item, idx|
        if item.match(/Content-Length:/)
          true_index = idx + 1
        end
      end 
    if !true_index.nil? and true_index != 0 
      begin
        eval("split_msg.slice!(0..#{true_index})")
        new_msg = split_msg.to_s
        arry_match = new_msg.scan(/<!--\n{0,}.+?\n{0,}-->/) 
          arry_match.each do |item|
            File.open(file, "a") {|f| f.write("HTML COMMENT IN: #{rhost}#{url}\r\n==========================\n\n#{item}\n")}
          end
      rescue => $!
        "The following error occured: #{$!}"
      end
    end   
  end   
end

#
#
#
def $burp.evt_proxy_message(*param)
  msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
    if is_req == false
      prefix = is_req ? "https://" : "http://"
      rurl = "#{prefix}#{rhost}"
       if (rurl) and $burp.isInScope(rurl)
         process_html_comments(url, rhost, rport, prefix, message)
       end
    end
  return super(*param)
end