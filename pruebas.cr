module FirstModule
	@@myVar = 30
	def get_text
		3
	end
	def firstFun
		puts "Miau#{self.get_text}"
	end
end
module NewModule 
	extend FirstModule
	
	
	@@cosa = 5
	def self.get_text
		puts typeof(@@cosa)
		puts @@cosa
	end
end
class SuperClase
	class Ola
	end
	include NewModule
end

class Table(T)
	def initialize()
		@array = Array.new(1) { Array(T).new(0) }
	end
	def [](row : Int, column : Int)
		@array[row][column]
	end
	def [](row : Int)
		@array[row]
	end
	def []=(row : Int, column : Int,value : T)
		@array[row][column] = value
	end
	def push(row : Int, value : T)
		if row > @array.length() -1
			(@array.length..row).each do |num|
				@array.push(Array(T).new(0))
			end
		end
		@array[row].push(value)
	end

end
class Ola
end
d = Table(Int32).new
d.push(10,20)

b = Array(Ola).new(0) 

b.push(Ola.new)


