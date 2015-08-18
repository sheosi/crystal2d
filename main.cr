require "sdl2"
require "./sdlFix"
require "./crystal2d"

class MyGame < SDLApp
	def on_init
		@spr = Sprite.new(@main_renderer)
	end

	def on_render
		@spr.render
	end

	def on_game_frame(timestep)
		@spr.x =@spr.x + 100*timestep
	end
	
	def on_event(event)
		if event.type == SDL2::EventType::QUIT || event.type == SDL2::EventType::KEYDOWN
			@is_running = false
		end
	end
end

MyGame.new.run