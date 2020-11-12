class User < Human
	def initialize
		name = ['Alice', 'Bob', 'Jack', 'Rose'].sample
		friends = []
		friends << name
		happy = false
	end
end
