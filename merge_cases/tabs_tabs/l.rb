class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = false
	end
	
	def make_friends
		while true                                    
			new_friend = User.new
			friends << new_friend
			if friends.count > 100
				happy = true          
			end
		end
	end
end
