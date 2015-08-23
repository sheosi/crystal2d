module Crystal2d

	#A structure which is basically an array of arrays
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

		def each

			@array.each do |row|
				row.each do |cell|
					yield cell
				end
			end

		end
	end #class Table

end #module Crystal2d