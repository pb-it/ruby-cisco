require 'net/telnet'

module Cisco

  class Telnet
    
    include Common

    def initialize(options)
		@host    = options[:host]
		@username = options[:username] || nil
		@password = options[:password]
		@enablepass = options[:enablepass] || "setmeimfamous"
		@prompt  = options[:prompt]
		@targs   = options[:directargs] || ["Host" => @host]
		@pwprompt = options[:pwprompt] || "Password:"
		@cmdbuf, @extra_init = [], []
		@telnet=nil
		@loggedin=false
		@enabled=false
		@interfaces={}
    end

	def connect
		@telnet = Net::Telnet.new(*@targs)
	end

    def run
      @results = []
      (@cmdbuf = [] and yield self) if block_given?
      @cmdbuf.insert(0, *@extra_init) if @extra_init.any?
	  connect if @telnet.nil?
      login if @loggedin == false
      until @cmdbuf.empty?
        send_next
        @results << @telnet.waitfor(@prompt) {|x| @outblock.call(x) if @outblock}
      end
      
      @results
    end

    def cmd(cmd, prompt = nil, &block)
      @cmdbuf << [cmd, prompt, block]
    end
    
    def close
      10.times do
        chn.send_data("exit\n") while @telnet.sock
      end
    end

    def load_interfaces
    	#backup
    	old_cmd = @cmdbuf

		#self.enable if @enabled==false
		# do stuff
    	cmd("show interface status")
    	rslt=self.run
		list = rslt[1].split("\n")

		# drop junk at start & end
		3.times do list.shift end
		list.pop
		
		regexp=%r{([A-Z][a-z]\d/\d+)(\s+)(.*)(notconnect|connected)(\s+)(\d+)(\s+)(\w-?\w+)(\s+)(\w-?\w+)(\s+)(.*)}
		# each line is : port name status vlan duplex speed type
		# eg : Gi0/46    Vers switch mgmt   notconnect   10           auto   auto Not Present
    	list.each { |line|
			if m=regexp.match(line) then
				@interfaces[m[1]] = Cisco::Interface.new(:port => m[1], 
                    :name => m[3].strip, 
			        :status => m[4], 
			        :vlan => m[6], 
			        :duplex => m[8], 
			        :speed => m[10], 
			        :type => m[12])
			end
		}

    	#restore
    	@cmdbuf = old_cmd
    end

	def list_interfaces
		@interfaces.keys
	end

    private

    def login
		raise CiscoError.new("No login password provided.") unless @password
		if @username != nil then
			@results << @telnet.waitfor(Regexp.new("Username:"))
			@telnet.puts(@username)
		end
		@results << @telnet.waitfor(Regexp.new("Password:"))
		@telnet.puts(@password)
		@results << @telnet.waitfor(@prompt)
		@loggedin = true
    end

    def	send_next
      cmd = @cmdbuf.shift
      @prompt = Regexp.new(cmd[1]) if cmd[1]
      @outblock = cmd[2] if cmd[2]
      @telnet.puts(cmd.first)
    end



  end

end
