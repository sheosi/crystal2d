module Crystal2d
	class Sprite
		property :is_visible
		def initialize(path : String,layer = 0, app = $main_app,@is_visible = true )
			@renderer = app.get_renderer
			@tex = SDL2::Texture.new(path, @renderer)
			@size = SDL2::Rect.new(0, 0, @tex.w, @tex.h)
			@x_bias = 0
			@y_bias = 0
			app.add_sprite self
		end

		def initialize(path : String,@renderer : SDL2::Renderer | LibSDL2::Renderer)
			
			@tex = SDL2::Texture.new(path, @renderer)
			@size = SDL2::Rect.new(0, 0, @tex.w, @tex.h)
			@x_bias = 0
			@y_bias = 0
		end

		def render
			if @is_visible
				@renderer.copy(@tex,nil,@size)
			end
		end
		macro coordinate (c)
			def {{c}}
				@size.{{c}} + @{{c}}_bias
			end 
			def {{c}}=({{c}})
				@size.{{c}} = {{c}}
			end
			def {{c}}=({{c}} : (Float32|Float64) )
				actual_{{c}} = {{c}}.to_i32
				@{{c}}_bias = @{{c}}_bias + ({{c}}-actual_{{c}})
				if @{{c}}_bias > 1.0
					@{{c}}_bias -= 1.0
					actual_{{c}} += 1
				end
				@size.{{c}} = actual_{{c}}

			end
		end
		
		coordinate x
		coordinate y

	end
	class SDLApp
		def add_sprite( spr : Sprite , layer = 0)
			@__draw_table.push(layer,spr)
		end
	end


end