
module Crystal2d
	#A recopolation of all types which can be used to trigger an event
	alias EventTrigger = SDL2::Scancode | LibSDL2::Key | SDL2::EventType

	#Which kind of input is it
	enum EventAction
		OnOff
		Toggle
		Bind
		SetAbsolute
		SetRelative
	end

	#Constants to make the application code prettier
	OnOff = EventAction::OnOff
	Toggle = EventAction::Toggle
	Bind = EventAction::Bind
	SetAbsolute = EventAction::SetAbsolute
	SetRelative = EventAction::SetRelative

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

	#Holds the data of the
	class EventReg
		property :type, :event_registered,:var
		def initiliaze(@type : EventAction,@event_registered: EventTrigger,@var)
		end


    	#A macro to simplify the writing of the handling of events
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
			end
		end
    
		
		#Where the events are handled and the desired action is done
		def input_action(event)
			case @type
			when OnOff
				whenType SDL2::EventType::KEYDOWN , false,
						 SDL2::EventType::KEYUP	  , true,	 
					     SDL2::EventType::FIRSTEVENT , true	 
			end
		end

	end #class EventReg

	#A glorified hash of arrays which hold event registers
	class InputHash

		def initialize()
			@hash = {} of Array(EventTrigger) => EventReg
		end

		#When a event happens
		def on_event_received(event)
			#FIXME:
			#TODO:
		end

		#Add a event register to the hash
		def add_register(register)
			@hash[register.event_registered].push(register)
		end
	end

	class App
		#Creates a method which register the signals told
  		macro signal(var,input,input_action)
  			add_new_signal(pointerof({{var}}),{{input}},{{input_action}})
  		end

  		#This function takes information packs them into event registers
  		#   and finally,adds them to the hash
  		def add_new_signal(var, input, input_action)
  			@__input_hash
  		end

  		#This function is meant to be used inside the class definition (but outside a method)
  		#Creates a hidden function which is called by run and does the actual registering
		macro define_signals(*args)
  			private def __register_signals
  				{%for element,index in args%}
  					{%if index%3 == 0 %}
  						{%variable = element%}
  					{%elsif index%3 == 1 %}
  						{%input = element%}
  					{%else%}
  						{%input_action = element%}
  						add_new_signal(pointerof(@{{variable.id}}),{{input}}, {{input_action}} )
  					{%end%}
  				{%end%}
  			end
  		end

	end	
end