require "sdl2"
require "./sdl2image"
require "./sdlFix"
$main_app =nil
struct Nil
	macro method_missing(name,args,block)
		SDL2.raise("Attempt to call {{name.id}} on Nil")
	end
end
def not(bool)
	!bool
end
	 
module Crystal2d
	

	extend self

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
	
	end

	class Sprite
		def initialize(path : String,layer = 0, app = $main_app)
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
			@renderer.copy(@tex,nil,@size)
		end

		def x
			@size.x + @x_bias
		end 
		def x=(x)
			@size.x = x
		end
		def x=(x : (Float32|Float64) )
			actual_x = x.to_i32
			@x_bias = @x_bias + (x-actual_x)
			if @x_bias > 1.0
				@x_bias -= 1.0
				actual_x += 1
			end
			@size.x = actual_x

		end
		def y
			@size.y + @y_bias
		end
		def y=(y)
			@size.y = y
		end
		def y=(y : (Float32|Float64))
			actual_y = y.to_i32
			@y_bias = @y_bias + (y-actual_y)
			if @y_bias > 1.0
				@y_bias -= 1.0
				actual_y += 1
			end
			@size.y = actual_y
		end
	end
	enum InputAction
		OnOff
		Toggle
		Bind
		SetAbsolute
		SetRelative
	end
	OnOff = InputAction::OnOff
	Toggle = InputAction::Toggle
	Bind = InputAction::Bind
	SetAbsolute = InputAction::SetAbsolute
	SetRelative = InputAction::SetRelative



    #APP_TERMINATING
    #APP_LOWMEMORY
    #APP_WILLENTERBACKGROUND
    #APP_DIDENTERBACKGROUND
    #APP_WILLENTERFOREGROUND
    #APP_DIDENTERFOREGROUND
    #WINDOWEVENT    = 0x200
    #SYSWMEVENT
	
    #KEYDOWN        = 0x300
    #KEYUP
    #TEXTEDITING
    #TEXTINPUT

    #MOUSEMOTION    = 0x400
    #MOUSEBUTTONDOWN
    #MOUSEBUTTONUP
    #MOUSEWHEEL

    #JOYAXISMOTION  = 0x600
    #JOYBALLMOTION
    #JOYHATMOTION
    #JOYBUTTONDOWN
    #JOYBUTTONUP
    #JOYDEVICEADDED
    #JOYDEVICEREMOVED

    #CONTROLLERAXISMOTION  = 0x650
    #CONTROLLERBUTTONDOWN
    #CONTROLLERBUTTONUP
    #CONTROLLERDEVICEADDED
    #CONTROLLERDEVICEREMOVED
    #CONTROLLERDEVICEREMAPPED

    #FINGERDOWN      = 0x700
    #FINGERUP
    #FINGERMOTION

    #DOLLARGESTURE
    #DOLLARRECORD
    #MULTIGESTURE

    #CLIPBOARDUPDATE = 0x900

    #DROPFILE        = 0x1000

    #RENDER_TARGETS_RESET = 0x2000

    #USEREVENT    = 0x8000

    #LASTEVENT    = 0xFFFF
    #private macro startWhen()
    	#case event.type
    #end
    private macro whenType(eventType,val)
		when {{eventType}}
			@var.value = {{val}}
		
	end
	class InputReg
		def initiliaze(@type : InputAction,@var)
		end

		def input_action(event)
			case @type
			when OnOff
				case event.type
				when SDL2::EventType::KEYDOWN
					@var.value = false
				when SDL2::EventType::KEYUP
					@var.value = true
				when SDL2::EventType::FIRSTEVENT
					@var.value = true
				end
			end
		end
	end


class SDLApp
	@limit_fps = true
	@max_fps = 60
	@sdl_flags = SDL2::INIT::VIDEO
	@window_width = 640
	@window_height = 480
	@window_title = "An SDL2 application"
	@window_flags = SDL2::Window::Flags::SHOWN
	@v_sync = true
	@renderer_flags = SDL2::Renderer::Flags::ACCELERATED
	@use_png  = true
	@use_jpg  = true
	@use_tif  = true
	@use_webp = true

	def get_sdl_flags
		@sdl_flags
	end
	def get_window_width
		@window_width
	end
	def get_window_height
		@window_height
	end
	def get_window_flags
		@window_flags
	end
	def get_window_title
		@window_title
	end
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
	stub on_init
	stub on_exit
	stub on_game_frame,time_step
	###########################
	###########################
	def on_event(event)
		
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
		@__input_hash = {} of SDL2::Scancode | LibSDL2::Key | SDL2::EventType => InputReg
		@__draw_table = Table(Sprite).new
		$main_app = self
	end
	
	macro signal(var,scancode, actionType)
		#scancode : SDL2::Scancode
		#keysym : LibSDL2::Key
	end

	def add_sprite( spr : Sprite , layer = 0)
		@__draw_table.push(layer,spr)
	end
	def run
	on_init()
		#For maximum correctnes frame time and step time are separated
		total_time_until_last_step = SDL2.ticks

		#Just so that 
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
					puts ("Frame:#{current_frame_time},Sleep:#{(1000_f32 / @max_fps) - current_frame_time},Actual delay:#{actual_delay},Bias:#{sleep_bias}")
					SDL2.delay( actual_delay)
				else
					sleep_bias = 0
					puts ("Frame:#{current_frame_time}")
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