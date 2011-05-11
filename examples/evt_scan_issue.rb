# Example evt_scan_issue
# This is an example script, in attempt to teach Buby

def prnt(*objs)
  strn, meth = objs  
  str = ''
  str << "\n#{strn}\n"
  str << '=' * strn.length + "\n\n"
  str << "#{meth}\n"
 puts str
end

def hm_prnt(*objs)
  strn, meth = objs
  str = ''
  str << "\n#{strn}\n"
  str << '=' * strn.length + "\n\n"
  meth.each do |itm|
    str << "#{itm.request_headers}\n"
    str << "#{itm.request_body}\n"
    str << "#{itm.response_headers}\n"
    str << "#{itm.response_body}\n"
  end
  puts str 
end


def $burp.evt_scan_issue(issue)
    meth_arry =  [
      'issue_name',
      'severity',
      'confidence',
      'protocol',
      'host',
      'url',
      'port',
      'issue_detail',
      'issue_background',      
      'remediation_detail',      
      'remediation_background',     
    ]
   
   meth_arry.each do |meth| 
     prnt("#{meth}", "#{issue.send("#{meth}")}")
   end
   
   hm_prnt('http_messages', issue.http_messages)
  # $burp.close
end