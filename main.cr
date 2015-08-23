require "sdl2"
require "./sdlFix"
require "./crystal2d"

class MyGame < Crystal2d::SDLApp
	
	define_signals :is_running,  LibSDL2::Key::ESCAPE,  Toggle,
			       :is_running,  SDL2::EventType::QUIT, Toggle,
	               :should_move, SDL2::Scancode::A,     OnOff

	def on_init
		@spr = Crystal2d::Sprite.new("char_1_side.png",0)
	end

	def on_game_frame(timestep)	
		@spr.x =@spr.x + 100*timestep if @should_move
	end
end

MyGame.new.run