require "sdl2"
require "./sdlFix"
require "./crystal2d"

class MyGame < Crystal2d::SDLApp
	signal :is_running, LibSDL2::Key::ESCAPE, Toggle
	signal :is_running, SDL2::EventType::QUIT, Toggle
	signal :should_move, SDL2::Scancode::A, OnOff

	def on_init
		@spr = Crystal2d::Sprite.new("char_1_side.png",0)
		@spr.is_visible = false
	end

	def on_game_frame(timestep)
		if @should_move
			@spr.x =@spr.x + 100*timestep
		end
	end
end

MyGame.new.run