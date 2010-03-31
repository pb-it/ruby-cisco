module Cisco
  
  module Common
    
    attr_accessor :host, :password, :prompt, :enablepass, :interfaces
    attr_reader :hwdata, :vlans
    
	def enable(pwprompt = nil)
		@pwprompt = pwprompt || @pwprompt
		old = @prompt
		cmd("enable", @pwprompt)
		cmd(@enablepass, old)
		self.run
		@enabled=true
	end

    def extra_init(*args)
		cmd(*args)
		@extra_init << @cmdbuf.pop
	end
		
	def clear_init
		@extra_init = []
	end
		
	def clear_cmd
		@cmdbuf = []
	end    
    
  end
  
end
