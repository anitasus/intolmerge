class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		if name == 'Jack'
			happy = true
		else
			false
		end
	end
	
	def make_friends
		while !happy
			friends << User.new
		end
	end
end
