module Crystal2d
	
	#A class which hold an image(which is expected to be drawn)
	class Sprite
		#is_visible controls whether is drawn or not
		property :is_visible

		#Standard initializing
		def initialize(path : String,layer = 0, @app = $main_app,@is_visible = true )
			@renderer = @app.get_renderer
			@tex = SDL2::Texture.new(path, @renderer)
			@size = SDL2::Rect.new(0, 0, @tex.w, @tex.h)
			@x_bias = 0
			@y_bias = 0
			@app.add_sprite self
		end

		#Initilizing directly through a render, note that is not registered anywhere
		#   so drawing must be done manually
		#def initialize(path : String,@renderer : SDL2::Renderer | LibSDL2::Renderer)
			#@tex = SDL2::Texture.new(path, @renderer)
			#@size = SDL2::Rect.new(0, 0, @tex.w, @tex.h)
			#@x_bias = 0
			#@y_bias = 0
		#end

		#Render itself into the display texture
		def render
			if @is_visible
				@renderer.copy(@tex,nil,@size)
			end
		end

		#X and Y coordinates
		macro coordinate (c)
			def {{c}}
				@size.{{c}} + @{{c}}_bias
			end 
			def {{c}}=({{c}})
				if true
					{%screen_size_name = "".id%}
					{%if c.id == "x".id%}   {%screen_size_name = "width".id%}
					{%elsif c.id =="y".id%} {%screen_size_name = "height".id%}
					{%end%}
					screen_{{screen_size_name}} = @app.usable_win_{{screen_size_name}}
					if ({{c}} < 0 && @size.{{c}}-{{c}} >= 0) || ({{c}} > 0 && @size.{{c}}+{{c}} <= screen_{{screen_size_name}})
						@size.{{c}} = {{c}}
					end
				end
			end
			def {{c}}=({{c}} : (Float32|Float64) )
				actual_{{c}} = {{c}}.to_i32
				@{{c}}_bias = @{{c}}_bias + ({{c}}-actual_{{c}})
				if @{{c}}_bias > 1.0
					@{{c}}_bias -= 1.0
					actual_{{c}} += 1
				end
				self.{{c}} = actual_{{c}}

			end
		end
		
		coordinate x
		coordinate y

	end #class Sprite

	class App

		#Add sprite to be rendered
		def add_sprite( spr : Sprite , layer = 0)
			@__draw_table.push(layer,spr)
		end
	end


end #module Crystal2d