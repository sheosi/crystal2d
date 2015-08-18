lib LibSDL2TTF
	#General
	fun linked_version = TTF_Linked_Version() : LibSDL2::Version*
	fun version = SDL_TTF_VERSION(LibSDL2::Version*)
	fun init = TTF_Init(): Int32
	fun was_init = TTF_WasInit(): Int32
	fun quit = TTF_Quit()
	fun set_error = TTF_SetError(UInt8*,...)
	fun get_error = TTG_GetError(): UInt8*

	#
end