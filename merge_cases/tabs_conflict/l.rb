class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		happy = false
	end
	
	def make_friends
		new_friend = User.new
		friends << new_friend
		happy = true
	end
end
