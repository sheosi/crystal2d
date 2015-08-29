require "sdl2"
require "./sdl2image"
require "./sdlFix"

require "./crystal2d_event"
require "./crystal2d_table"
require "./crystal2d_sprite"

#A global vairable to hold the default app (just there for convenience)
$main_app =nil

#A small hack, which avoids lots of 'ifs' everywhere
struct Nil
	macro method_missing(name,args,block)
		SDL2.raise("Attempt to call {{name.id}} on Nil")
	end
end

#not is easier to read than '!'
def not(bool)
	!bool
end
 
module Crystal2d
	#Main class, represents an application
	class App
	
		#Flags
		@sdl_flags = SDL2::INIT::VIDEO
		@renderer_flags = SDL2::Renderer::Flags::ACCELERATED
	
		#Window config
		@window_flags = SDL2::Window::Flags::SHOWN
		@window_title = "An SDL2 application"
		@window_width = 800
		@window_height = 600

		#Logical window (for resolution independent)
		@resolution_independent = true
		@logical_width = 800
		@logical_height = 600

		#Video config
		@v_sync = true
		@limit_fps = true
		@max_fps = 60
	
		#Image codecs
		@use_png  = true
		@use_jpg  = true
		@use_tif  = true
		@use_webp = true
	
		#Small macro to make variables getters
		macro func_get(var)
			def get_{{var.id}}
				@{{var.id}}
			end
		end

		#Variables getters
		func_get :sdl_flags
		func_get :window_width
		func_get :window_height
		func_get :window_flags
		func_get :window_title
		func_get :logical_width
		func_get :logical_height
	
	
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
		
		# Stub methods
		stub on_init
		stub on_exit
		stub on_game_frame,time_step
		stub __register_signals

		#Render handling
		def on_render
			@__draw_table.each do |sprite|
				sprite.render
			end
		end
		
		#App initializing
		def initialize
			SDL2.init(get_sdl_flags)
			@main_window = SDL2::Window.new(get_window_title, get_window_width,get_window_height,get_window_flags)
			SDL2::Image.init(get_sdl_image_flags)
			@main_renderer = SDL2::Renderer.new(get_window,-1,get_renderer_flags)

			if @resolution_independent
				LibSDL2.set_hint("SDL_RENDER_SCALE_QUALITY", "linear")
				LibSDL2.render_set_logical_size(@main_renderer,get_logical_width,get_logical_height)
			end

			@is_running = true
			@__event_hash = EventHash.new
			@__draw_table = Table(Sprite).new
			$main_app = self
		end
		
		#Application's loop
		def run
			#Application initialization
			on_init()

			#Function made by macro for registering input signals
			__register_signals
			
	
			#For maximum correctnes frame time and step time are separated
			#Measures time since last logic step
			total_time_until_last_step = SDL2.ticks
	
			
			time_start_frame = 0 #Measures time since the start of this frame
			#Since sleep is integer, this is the floating part of the real sleep
			#    time
			sleep_bias = 0_f32 
			
			#Just for testing
			start_render_time =  SDL2.ticks #Time since we started rendering
			frames = 1 #Frames drawn
			total_delay = 0 #Total time delayed
			# Total time taken by drawing an processing frames
			total_frame_time = 0 
	
			while @is_running
				#FPS capping logic is not needed as long as we have vsync
				if not @v_sync &&  @limit_fps
					time_start_frame = SDL2.ticks
				end
				#Process events
				SDL2.poll_events do |event|
					on_event(event)
				end

				#Now execute the game logic
				time_now = SDL2.ticks
				current_step_time = time_now - total_time_until_last_step
				total_time_until_last_step = time_now
	
				on_game_frame(current_step_time/1000_f32)

				#Now execute rendering
				@main_renderer.clear()
				on_render()
				@main_renderer.present()
	
				#Again this is all only if we don't have vsync
				if  not @v_sync && @limit_fps
	
					current_frame_time = SDL2.ticks - time_start_frame
					if current_frame_time < 1000_f32 / @max_fps 
						#We calculate the time to sleep
						original_delay = 1000_f32 / @max_fps - current_frame_time
						actual_delay = original_delay.to_u32
						
						#how much we lost when transforming into an integer
						sleep_bias = sleep_bias + (original_delay - actual_delay)
						
						#if the bias is enough, do a correction
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
				end #end of fps capping
				
				#Just to test
				if frames < @max_fps *3
					frames = frames +1
				else
					puts ("Time: #{SDL2.ticks-start_render_time}")
					puts ("Sleep bias: #{sleep_bias}")
					puts ("Total delay: #{total_delay}")
					puts ("Total frame time: #{total_frame_time}")
					@is_running = false
				end #end of testing
			end

			#Cleanup
			on_exit() 
			SDL2.quit
			
		end #def run

	end #class App
end #module Crystal2d

#There may be people who may get confused with the d, 
#    and it doesn't matter anyway
alias Crystal2D  = Crystal2d
#For many methods it's ugly to write Crystal2d::
include Crystal2D