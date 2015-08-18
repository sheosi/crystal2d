require "./lib_sdl2image"
module SDL2::Image
	@[Flags]
	enum Init_flags : Int32
		JPG
		PNG
		TIF 
		WEBP
	end
	def self.init(flags : Init_flags)
		LibSDL2Image.init(flags.value)
	end
end
def get_from_file(path : String,renderer : Pointer(LibSDL2::Renderer))
	surface = LibSDL2Image.load(path)
	texture = LibSDL2.create_texture_from_surface(renderer, surface)
	SDL2.raise("SDL can't load: {{path}}, has not a compatible extension") if not surface
	texture
	#SDL_PIXELFORMAT_RGB555 = 353570562
	#LibSDL2.create_texture(renderer,353570562_u32,LibSDL2::TextureAccess::STATIC,0,0)
	
end
class SDL2::Texture
	def initialize(path : String, renderer : Pointer(LibSDL2::Renderer))
		@texture = get_from_file(path, renderer)
	end
	def initialize(path : String, renderer : SDL2::Renderer)
		@texture = get_from_file(path, renderer.to_unsafe)
	end

end