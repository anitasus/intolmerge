class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = false
	end
	
	def make_friends
		while !happy
			friends << User.new
			if friends.count > 100
				happy = true
			end
		end
	end
	
	def eat
		while !happy
			super
		end
	end
end
