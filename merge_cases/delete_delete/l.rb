class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = true
	end
	
	def make_friends
		while !happy
			friends << User.new
		end
	end
end
