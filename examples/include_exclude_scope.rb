# Example excludeFromScope, includeInScope
# This is an example script, in attempt to teach Buby   

EXCLUSION_LIST = [    
  'CreateAccount.do',
  'RegisterAction.do',
  'action=Login.do',
  'action=registerNew.do'
]

INCLUSION_LIST = [    
  'user_id=',
  'uid=',
  'email=',
  'address1='
] 


PREFIX = [
  "http://",
  "https://"
]

PREFIX.each do |pre|
  EXCLUSION_LIST.each do |item|
    url = "#{pre}www.example.com:9050/#{item}"
    $burp.excludeFromScope(url)
  end
  INCLUSION_LIST.each do |item|
    url = "#{pre}www.example.com/#{item}"
    $burp.includeInScope(url)
  end
end
