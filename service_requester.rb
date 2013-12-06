# 
# Supose that need to perform a get request like
#
# 'http://baseurl/api/service/items?param1=value_for_param1&param2=value_for_param2&param3=value_for_param3'
#
# instance variables must be named equal to each parameter name. So for param1 must use @param1 and make it accessible

# require 'rest-client'

class ServiceRequester

	attr_accessor :param1, :param2, :param3
	attr_reader :base_url

	def initialize(base_url=nil)
		raise "No base url is given" if base_url.nil?
		@base_url = base_url
		@param1 	= "default_value_for_param1"
		@param2 	= "default_value_for_param2"
		@param3		= "default_value_for_param3"
		
		@all_params = [
			'param1',
			'param2',
			'param3']
	end

	def request params=@all_params
		puts url(params)
		# RestClient.get(url(params))
	end

	def url params
		params.inject("#{@base_url}?") do |result, param|
				value = try_get_value(param)
				result+=  value.empty? ? "" : "#{param}=#{value}&"
			end.chop
	end

	private 

	def try_get_value param
		begin
			send(param.to_sym) || ""
		rescue
			""
		end
	end
end


a = ServiceRequester.new("http://service.com/api/example/get")

# Change some values
a.param1 = "changed_value_1"
a.param3 = "changed_value_3"

puts a.request

puts a.request(["param1","param2"])
puts a.request(["param2","param3"])

# With a value that does not exist
puts a.request(["param2","param4"])
