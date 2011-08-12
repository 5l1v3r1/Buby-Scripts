#!/usr/bin/env ruby

require 'mechanize'

def mech_get(url)
  agent = Mechanize.new
  agent.set_proxy('127.0.0.1', 8080)
  agent.get('http://www.cnn.com')
end

def $burp.run
  proxy_hist = $burp.get_proxy_history
  
  if proxy_hist.length > 0
    proxy_hist.each do |itm|
      PHIST_METHODS.each {|meth| prnt("#{meth}", "#{itm.send(meth)}")}
    end
  end
end

