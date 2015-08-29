def get_from_file(path : String,renderer : Pointer(LibSDL2::Renderer))
	if File.extname(path)==".bmp"
		surface = SDL2.load_bmp_from_file("pruebas.bmp")
		LibSDL2.create_texture_from_surface(renderer,surface.to_unsafe)
	else
		SDL2.raise("SDL can't load: {{path}}, has not a compatible extension")
		#SDL_PIXELFORMAT_RGB555 = 353570562
		LibSDL2.create_texture(renderer,353570562_u32,LibSDL2::TextureAccess::STATIC,0,0)
	end
end
class SDL2::Texture
	def initialize(surf : Pointer(LibSDL2::Surface), renderer : Pointer(LibSDL2::Renderer))
		@texture = LibSDL2.create_texture_from_surface(renderer,surf)		
	end
	def initialize(surf : SDL2::Surface, renderer : SDL2::Renderer)
		@texture = LibSDL2.create_texture_from_surface(renderer.to_unsafe,surf.to_unsafe)
	end
	def initialize(surf : Pointer(LibSDL2::Surface), renderer : SDL2::Renderer)
		@texture = LibSDL2.create_texture_from_surface(renderer.to_unsafe,surf)		
	end
	def initialize(surf : SDL2::Surface, renderer : Pointer(LibSDL2::Renderer))
		@texture = LibSDL2.create_texture_from_surface(renderer,surf.to_unsafe)		
	end
	#Just a method which accepts
	def initiliaze(surf : Pointer(LibSDL::Surface) | SDL2::Surface |Nil, renderer : Pointer(LibSDL2::Renderer))
	end
	def free
		LibSDL2.destroy_texture(@texture)
	end

	def finalize
		self.free
	end

	def w
		result = 0
		LibSDL2.query_texture(self.to_unsafe,nil , nil, pointerof(result), nil)
		result
	end
	def h
		result = 0
		LibSDL2.query_texture(self.to_unsafe,nil , nil, nil, pointerof(result))
		result
	end

	def self.new_from_bmp_file(path, renderer : Pointer(LibSDL2::Renderer))
		surface = SDL2.load_bmp_from_file("pruebas.bmp")
		tex = SDL2::Texture.new(surface, renderer)
		surface.finalize
		tex
	end
	def self.new_from_bmp_file(path, renderer : SDL2::Renderer)
		new_from_bmp_file(path,renderer.to_unsafe)
	end
	
	
	def initialize(w, h, access, format, renderer : Pointer(LibSDL2::Renderer))
		@texture = LibSDL2.create_texture(renderer,format,access,w,h)
	end

	def initialize(w, h, access, format, renderer : SDL2::Renderer)
		@texture = LibSDL2.create_texture(renderer.to_unsafe,format,access,w,h)
	end
	def initialize(path : String,renderer : Pointer(LibSDL2::Renderer))
		@texture = get_from_file(path, renderer)
	end
	def initialize(path : String,renderer : SDL2::Renderer)
		@texture = get_from_file(path, renderer.to_unsafe)
	end
end

class SDL2::Window
	def initialize(title, width, height, flags : SDL2::Window::Flags)
		self.initialize(title,Window::POS_UNDEFINED, Window::POS_UNDEFINED, width,height,flags)
	end
end

class SDL2::Renderer
	def initialize(window : SDL2::Window, index, flags : SDL2::Renderer::Flags )
		@renderer = LibSDL2.create_renderer(window.to_unsafe, index, flags)
    	SDL2.raise "Can't create SDL render" unless @renderer
	end
	def free
		LibSDL2.destroy_renderer(@renderer)
	end
	def finalize
		self.free
	end
end

class SDL2::Surface
	def finalize
		self.free
	end
end

def SDL2.delay(num)
	SDL2.delay(1000.to_u32)
end
lib LibSDL2
	struct Version
	    major : UInt8        #< major version
    	minor : UInt8        #< minor version
    	patch : UInt8        #< update version
	end
	fun query_texture = SDL_QueryTexture(texture : LibSDL2::Texture*, format : UInt32*, access : Int32*, w : Int32*, h : Int32*)
	fun render_set_logical_size = SDL_RenderSetLogicalSize(renderer : LibSDL2::Renderer*, w : Int32, h : Int32) : Int32
	fun set_hint = SDL_SetHint(name : UInt8*, value : UInt8*) : Bool
end
 