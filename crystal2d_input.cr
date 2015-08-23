module Crystal2d_input
	alias InputTrigger = SDL2::Scancode | LibSDL2::Key | SDL2::EventType
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
    private macro whenType(*args)
    	case event.type
			{%for when_filter,index in args%}	
				{%if index%2 == 0%}
					{%value = when_filter%}
		    	{%else%}
			  		when {{when_filter}} 
			    		@var.value = {{value}}
				{%end%}
			{%end%}
		#end
	end
    
		
		
	end
	class InputReg
		property :type, :event_registered,:var
		def initiliaze(@type : InputAction,@event_registered: InputTrigger,@var)
		end

		def input_action(event)
			case @type
			when OnOff
				whenType SDL2::EventType::KEYDOWN , false,
						 SDL2::EventType::KEYUP	  , true,	 
					     SDL2::EventType::FIRSTEVENT , true	 
			end
		end
	end
	class InputHash
		def initialize()
			@hash = {} of Array(InputTrigger) => InputReg
		end
		def on_event_received(event)
			#FIXME:
			#TODO:
		end
		def add_register(register)
			@hash[register.event_registered].push(register)
		end
	end
	class SDLApp
	end
end