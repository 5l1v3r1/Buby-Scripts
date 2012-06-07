#!/usr/bin/env ruby

require 'java'
require 'zlib'
require 'stringio'
import java.awt.Dimension
import javax.swing.JFrame
import javax.swing.JPanel
import javax.swing.JTabbedPane
import javax.swing.GroupLayout
import javax.swing.JButton
import javax.swing.SwingConstants
import java.awt.event.WindowEvent
import javax.swing.JOptionPane
import javax.swing.JTextArea
import javax.swing.JScrollPane

class GzipFuPanel < JPanel
  
  def initialize(frame, is_response=nil)
    @is_response = is_response
    @frame = frame
    super()
    initUI
  end
  
  def initUI
    
    @close_b = JButton.new("Exit")
    @close_b.add_action_listener do |e|
      @frame.close_it     
    end
    
    @send_b = JButton.new("Forward")
    @send_b.enabled = false if @is_response
    @ta1 = JTextArea.new
    @ta1.editable = false if @is_response
    @sp1 = JScrollPane.new(@ta1)
   
    #
    # GROUP LAYOUT OPTIONS
    #
    
    layout = GroupLayout.new self
    # Add Group Layout to the frame
    self.setLayout layout
    # Create sensible gaps in components (like buttons)
    layout.setAutoCreateGaps true
    layout.setAutoCreateContainerGaps true
  
    sh1 = layout.createSequentialGroup
    sv1 = layout.createSequentialGroup
    sv2 = layout.createSequentialGroup
    sv3 = layout.createSequentialGroup

    p1 = layout.createParallelGroup
    p2 = layout.createParallelGroup
    
    layout.setHorizontalGroup sh1
    layout.setVerticalGroup sv3
    
    sv1.addComponent(@sp1)
    sv2.addComponent(@close_b)
    sv2.addComponent(@send_b)
    sv3.addGroup(sv1)
    sv3.addGroup(sv2)
    
    
    p2.addComponent(@close_b)
    p2.addComponent(@send_b)
    sh1.addComponent(@sp1)
    sh1.addGroup(p2)
    
    layout.linkSize SwingConstants::HORIZONTAL, 
        @close_b, @send_b
    
  end
  
  def send_to_panel(str='')
    @ta1.text = '' && @ta1.text = str
  end
  
end 


class GzipFuSubTabbedPane < JTabbedPane
  
  def initialize(frame)
   super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT) 
   @t1 = GzipFuPanel.new(frame)
   @t2 = GzipFuPanel.new(frame, true)
   add("request", @t1 )
   add("response", @t2)
  end 
  
  def set_request_text(str='')
    @t1.send_to_panel(str)
  end 
  
  def set_response_text(str='')
    @t2.send_to_panel(str)
  end 
    
end

class GzipFuTabbedPane < JTabbedPane
  
  attr_accessor :gfps
  
  def initialize(frame)
    super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
    @frame = frame
    self.gfps = []
    add_panel
  end 
  
  def add_panel
    gfp = GzipFuSubTabbedPane.new(@frame)
    self.gfps.push(gfp)
    add("#{self.gfps.length}", gfp)
  end 
  
  def send_to_request(str='')
    self.gfps.last.set_request_text(str)
  end 
  
  def send_to_response(str='')
    self.gfps.last.set_response_text(str)
  end
  
end 


class GzipFuFrame < JFrame
  
  attr_accessor :gftp
  
  def initialize
    super("GZip-F.U.")
    init
  end 
  
  def init
    
    self.addWindowListener do |e|
      if e.kind_of?(WindowEvent)
       ps = e.paramString.split(',')[0] == "WINDOW_CLOSING" ? true : false
       if (ps)
         close_it
       end        
      end
     end
     
    self.gftp = GzipFuTabbedPane.new(self)
    self.add self.gftp

    # Set the overall side of the frame
    self.setJMenuBar menuBar
    self.setPreferredSize Dimension.new(1300, 900)
    self.pack
  
    self.setDefaultCloseOperation JFrame::DO_NOTHING_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true 
  end
  
  def close_it
    jo = JOptionPane.showConfirmDialog(nil, 
           "Close this window?", 
           "Confirmation", 
           javax.swing.JOptionPane::YES_NO_OPTION, 
           javax.swing.JOptionPane::QUESTION_MESSAGE)
    if jo == JOptionPane::YES_OPTION
      self.dispose()
    end
  end
  
  def send_to_request(str='')
    self.gftp.send_to_request(str)
  end 
  
  def send_to_response(str='')
     self.gftp.send_to_response(str)
  end
  
end

$gzf = GzipFuFrame.new
$gzf.send_to_request("I\'m a request")
$gzf.send_to_response("I\'m a response")

def gzip?(gzip_str='')
  e = nil
  return false if gzip_str.nil? || gzip_str.empty?
  begin
     gz = Zlib::GzipReader.new(StringIO.new(gzip_str)) and gz.close
   rescue Exception => e
   end
   result = e ? false : true
   return result
end

def $burp.evt_proxy_message(*param)
    msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action = param
    @str = ''
    @e = nil  
      msg = message.split(/\r\n\r\n/)
      body = msg[1]
      return super(*param) unless gzip?(body)
      if not body.nil?
        gz = Zlib::GzipReader.new(StringIO.new(body))
        body = gz.read
        gz.close
        msg[0].gsub!(/\r\nContent-Encoding: gzip\r\nContent-Length: (.*)/, "") if not msg[0].nil?
        @str << msg[0]
        @str << "\r\n\r\n#{body}"
      end
      $gzf.send_to_gui(@str) if is_req   
      return super( msg_ref, is_req, rhost, rport, is_https, http_meth, url, resourceType, status, req_content_type, message, action)   
end
