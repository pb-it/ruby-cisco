Gem::Specification.new do |s|
  s.name = "cisco"
  s.version = "0.0.2"
  s.date = "2010-03-26"
  s.authors = ["nico."]
  s.email = "nico@rottenbytes.info"
  s.rubyforge_project = "cisco"
  s.has_rdoc = false
  s.summary = "Library for accessing Cisco devices via Telnet and SSH"
  s.homepage = "http://www.github.com/rottenbytes/ruby-cisco"
  s.description = "This tool aims to provide transport-flexible functionality, for easy communication
                  with Cisco devices. It currently allows you to execute commands on a device and get
                  back the output of those commands."
  s.files = ["README",
             "lib/cisco.rb",
             "lib/cisco/common.rb",
             "lib/cisco/telnet.rb",
             "lib/cisco/base.rb",
             "lib/cisco/ssh.rb",
             "lib/cisco/interfaces.rb"]
  s.add_dependency('net-ssh')
end
