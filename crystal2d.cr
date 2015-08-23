require "sdl2"
require "./sdl2image"
require "./sdlFix"

require "./crystal2d_input"
require "./crystal2d_table"
require "./crystal2d_sprite"
#A global vairable to hold the default app (just there for convenience)
$main_app =nil

#A small fix
struct Nil
	macro method_missing(name,args,block)
		SDL2.raise("Attempt to call {{name.id}} on Nil")
	end
end

#
def not(bool)
	!bool
end
 
module Crystal2d

	
class SDLApp

	#Flags
	@sdl_flags = SDL2::INIT::VIDEO
	@renderer_flags = SDL2::Renderer::Flags::ACCELERATED

	#Window config
	@window_flags = SDL2::Window::Flags::SHOWN
	@window_title = "An SDL2 application"
	@window_width = 640
	@window_height = 480
	
	#Video config
	@v_sync = true
	@limit_fps = true
	@max_fps = 60

	#Image codecs
	@use_png  = true
	@use_jpg  = true
	@use_tif  = true
	@use_webp = true

	macro func_get(var)
		def get_{{var.id}}
			@{{var.id}}
		end
	end
	func_get :sdl_flags
	func_get :window_width
	func_get :window_height
	func_get :window_flags
	func_get :window_title


	def get_renderer
		@main_renderer
	end
	def get_window
		@main_window
	end
	def get_renderer_flags
		rflags = @renderer_flags
		if @v_sync
			rflags = rflags | SDL2::Renderer::Flags::PRESENTVSYNC
		end
		rflags
	end
	def get_sdl_image_flags
		result = SDL2::Image::Init_flags::None
		result = result | SDL2::Image::Init_flags::PNG if @use_png
		result = result | SDL2::Image::Init_flags::JPG if @use_jpg
		result = result | SDL2::Image::Init_flags::TIF if @use_tif
		result = result | SDL2::Image::Init_flags::WEBP if @use_webp		
		result
	end
	
	macro stub(name)
		def {{name}}
		end
	end
	macro stub(name,arg)
		def {{name}}({{arg}})
		end
	end
	###########
	# Stub methods
	###########
	#replace this by if responds_to
	stub on_init
	stub on_exit
	stub on_game_frame,time_step
	stub __register_signals
	###########################
	###########################
	def on_event(event)
		@__input_hash.on_event_received(event)
	end

	def on_render
		@__draw_table.each do |sprite|
			sprite.render
		end
	end
	##############

	def initialize
		SDL2.init(get_sdl_flags)
		@main_window = SDL2::Window.new(get_window_title, get_window_width,get_window_height,get_window_flags)
		SDL2::Image.init(get_sdl_image_flags)
		@main_renderer = SDL2::Renderer.new(get_window,-1,get_renderer_flags)
		@is_running = true
		@__input_hash = InputHash.new
		@__draw_table = Table(Sprite).new
		$main_app = self
	end

	def run
		on_init()
		__register_signals
		

		#For maximum correctnes frame time and step time are separated
		total_time_until_last_step = SDL2.ticks

		
		time_start_frame = 0
		sleep_bias = 0_f32
		

		start_render_time =  SDL2.ticks
		frames = 1
		total_delay = 0
		total_frame_time = 0

		while @is_running
			if not @v_sync &&  @limit_fps
				time_start_frame = SDL2.ticks
			end
			SDL2.poll_events do |event|
				on_event(event)
			end
			@main_renderer.clear()
			on_render()
			@main_renderer.present()

			time_now = SDL2.ticks
			current_step_time = time_now - total_time_until_last_step
			total_time_until_last_step = time_now

			on_game_frame(current_step_time/1000_f32)
			if  not @v_sync && @limit_fps

				current_frame_time = SDL2.ticks - time_start_frame
				if current_frame_time < 1000_f32 / @max_fps 
					
					original_delay = 1000_f32 / @max_fps - current_frame_time
					actual_delay = original_delay.to_u32

					sleep_bias = sleep_bias + (original_delay - actual_delay)
					
					if sleep_bias > 1
						sleep_bias = sleep_bias - 1
						actual_delay = actual_delay +1
					end
					total_frame_time = total_frame_time + current_frame_time
					total_delay = total_delay+actual_delay
					SDL2.delay( actual_delay)
				else
					sleep_bias = 0
				end
			end

			if frames < @max_fps
				frames = frames +1
			else
				puts ("Time: #{SDL2.ticks-start_render_time}")
				puts ("Sleep bias: #{sleep_bias}")
				puts ("Total delay: #{total_delay}")
				puts ("Total frame time: #{total_frame_time}")
				@is_running = false
			end
		end
		on_exit()
		SDL2.quit
	end
	
	end
end
alias Crystal2D  = Crystal2d
include Crystal2d