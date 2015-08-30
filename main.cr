require "sdl2"
require "./sdlFix"
require "./crystal2d"

class TileSprite < Sprite
	def initialize(@tile_image, layer = 0, @is_visible = true)
		@app = @tile_image.app
		@renderer = app.get_renderer
		@tex = SDL2::Texture.new(path, @renderer)
		@size = SDL2::Rect.new(0, 0, @tex.w, @tex.h)
		@x_bias = 0
		@y_bias = 0
	end
end
class MyGame < Crystal2d::App
	
	define_signals :is_running,  SDL2::EventType::QUIT,  Toggle,
			       :is_running,  SDL2::Scancode::ESCAPE, Toggle,
	               :should_move, SDL2::Scancode::A,     OnOff,
	               :should_move_backwards,  SDL2::Scancode::S,     OnOff

	def on_init	
		@spr = Crystal2d::Sprite.new("char_1_side.png",0)
	end

	def on_game_frame(timestep)	
		@spr.x =@spr.x + 100*timestep if @should_move
		@spr.x =@spr.x - 100*timestep if @should_move_backwards
	end
end

MyGame.new.run