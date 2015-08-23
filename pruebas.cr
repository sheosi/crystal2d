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
macro actions(*actions)
	#scancode : SDL2::Scancode
	#keysym : LibSDL2::Key
   	private def add_actions
   	  {% for action in actions %}
       	@actions[{{action}}.to_s] = ->{{action.id}}
   	  {% end %}
   	end
end
class Ola
	#actions :hola
	@newVar = 0
	def initialize
		setVar pointerof(@newVar)
	end
	def setVar(var)
		var.value = 2 
	end
	def printVar

		puts @newVar
	end	
	def set_not_a_var
		@not_a_var = 2000
	end
	def testvar
		pointer = pointerof(@not_a_var)	
		set_not_a_var
		puts pointer.value
	end
end

Ola.new.testvar


macro startWhen(*args)
	{%tempVar = 0%}
	puts "case event.type"
	{%for when_filter,index in args%}	
		{%if index%2 == 0%}
			{%value = when_filter%}
		{%else%}
			puts "when {{when_filter.id}} @var.value = {{value.id}}"
		{%end%}
	{%end%}
end
startWhen :gola,"Uhu", 
		"mwh", lololo