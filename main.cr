require "sdl2"
require "./sdlFix"
require "./crystal2d"

class MyGame < Crystal2d::SDLApp
	signal :should_move, SDL2::Scancode::A, Crystal2d::InputAction::OnOff
	def on_init
		@spr = Crystal2d::Sprite.new("char_1_side.png",@main_renderer)
	end

	def on_render
		@spr.render
	end

	def on_game_frame(timestep)
		if @should_move
			@spr.x =@spr.x + 100*timestep
		end
	end
	
	def on_event(event)
		if event.type == SDL2::EventType::QUIT
			@is_running = false
		elsif event.type == SDL2::EventType::KEYDOWN
			if event.key.key_sym.sym == LibSDL2::Key::ESCAPE
				@is_running = false
			elsif event.key.key_sym.sym == LibSDL2::Key::A
				@a_pressed = true
			end
		elsif event.type == SDL2::EventType::KEYUP
			if event.key.key_sym.sym == LibSDL2::Key::A
				@a_pressed = false
			end
		end
	end
end

MyGame.new.run