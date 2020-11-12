class User < Human
	def initialize
		name = ['Alice', 'Bob', 'John', 'Rose'].sample
		friends = []
		happy = true
	end
	
	def make_friends
		while !happy
			friends << User.new
			if friends.count > 100
				happy = true
			end
		end
	end
end
