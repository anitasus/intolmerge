class User < Human
	def initialize
		name = ['Alice', 'Bob', 'John', 'Rose'].sample
		friends = ['Alice']
		happy = false
	end
end
