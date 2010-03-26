module Cisco
	
	class Interface
		attr_accessor :port, :name, :speed, :duplex, :status, :vlan, :type

		def initialize(options)
			@port = options[:port]
			@name = options[:name] || nil
			@speed = options[:speed] || 100
			@duplex = options[:mode] || "Full-duplex"
			@status = options[:status] || "notconnect"
			@vlan = options[:vlan] || "1"
			@type = options[:type] || "10/100/1000BaseTX"
		end
		
	end
	
end
