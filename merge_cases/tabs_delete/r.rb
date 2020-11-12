class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = false
	end
	
	def make_friends
		new_friend = User.new
		friends << new_friend
		friends = friends + new.friend.friends
		if friends.count > 100
			happy = true
		end
	end
end
