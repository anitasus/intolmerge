class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = true
	end
	
	def make_friends
		while !happy
			friends << User.new
			if friends.count > 100
				happy = false
			end
		end
	end
end
