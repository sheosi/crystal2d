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
	inclue NewModule
end