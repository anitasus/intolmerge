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
end
