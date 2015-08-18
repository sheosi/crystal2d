require "sdl2/lib_sdl2"
require "./sdlFix"
@[Link("SDL2_image")]
lib LibSDL2Image
	#General
	fun linked_version = IMG_Linked_Version() : LibSDL2::Version
	fun image_version = SDL_IMAGE_VERSION(LibSDL2::Version*)
	fun init = IMG_Init(Int32): Int32
	fun quit = IMG_Quit()

	#Loading
	fun load = IMG_Load(UInt8*): LibSDL2::Surface*
	fun load_rw = IMG_Load_RW(LibSDL2::RWops*,Int32): LibSDL2::Surface*
	fun load_typed_rw = IMG_LoadTyped_RW(LibSDL2::RWops*,Int32,UInt8*): LibSDL2::Surface*
	fun load_cur_rw = IMG_LoadCUR_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_ico_rw = IMG_LoadICO_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_bmp_rw = IMG_LoadBMP_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_pnm_rw = IMG_LoadPNM_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_xpm_rw = IMG_LoadXPM_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_xcf_rw = IMG_LoadXCF_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_pcx_rw = IMG_LoadPCX_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_gif_rw = IMG_LoadGIF_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_jpg_rw = IMG_LoadJPG_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_tif_rw = IMG_LoadTID_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_png_rw = IMG_LoadPNG_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_tga_rw = IMG_LoadTGA_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_lbm_rw = IMG_LoadLBM_RW(LibSDL2::RWops*) : LibSDL2::Surface
	fun load_xv_rw  = IMG_LoadXV_RW (LibSDL2::RWops*) : LibSDL2::Surface
	fun read_XPMF_from_array = IMG_readXPMFFromArray(UInt8**) : LibSDL2::Surface
	
	#Info
	fun is_CUR = IMG_isCUR(LibSDL2::RWops): Int32
	fun is_ico = IMG_isICO(LibSDL2::RWops): Int32
	fun is_bmp = IMG_isBMP(LibSDL2::RWops): Int32
	fun is_pnm = IMG_isPNM(LibSDL2::RWops): Int32
	fun is_xpm = IMG_isXPM(LibSDL2::RWops): Int32
	fun is_xcf = IMG_isXCF(LibSDL2::RWops): Int32
	fun is_pcx = IMG_isPCX(LibSDL2::RWops): Int32
	fun is_gif = IMG_isGIF(LibSDL2::RWops): Int32
	fun is_jpg = IMG_isJPG(LibSDL2::RWops): Int32
	fun is_tif = IMG_isTIF(LibSDL2::RWops): Int32
	fun is_png = IMG_isPNG(LibSDL2::RWops): Int32
	fun is_lbm = IMG_isLBM(LibSDL2::RWops): Int32
	fun is_xv  = IMG_isXV (LibSDL2::RWops): Int32

	fun set_error = IMG_SetError(UInt8*, ...)
	fun get_error = IMG_SetError(): UInt8*
	#Defines
	MAJOR_VERSION = 2
	MINOR_VERSION = 0
	PATCHLEVEL = 0
end