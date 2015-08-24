enum LibSDL2::Key
  def <=>(other)
    #FIXME:
    0
  end
end
enum SDL2::EventType
  def <=>(other)
    #FIXME:
    0
  end
end
enum SDL2::Scancode
  def <=>(other)
    #FIXME:
    0
  end
end
module Crystal2d
	#A recopilation of all types which can be used to trigger an event
	alias EventTrigger = SDL2::Scancode | LibSDL2::Key | SDL2::EventType

  alias EventHandler = LibSDL2::Event -> Nil
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

  #FIXME:
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
		def initialize(@type : EventAction,@event_registered: EventTrigger, @var: Pointer(Nil|Bool))      
		end
    def initialize(@type : EventAction,@event_registered: EventTrigger, &@func: EventHandler)
    end 

    	#A macro to simplify the writing of the handling of events
    	private macro whenType(*args)
	    	case event.type
				{%for value,index in args%}	
					{%if index%2 == 0%}
						{%when_filter = value%}
		    		{%else%}
				  		when {{when_filter}} 
			    			@var.value = {{value}}
					{%end%}
				{%end%}
			end
		end
    
		
		#Where the events are handled and the desired action is done
		def event_action(event)
			case @type
			when OnOff
        @var.value.try do 
				  whenType  SDL2::EventType::KEYDOWN , true,
						        SDL2::EventType::KEYUP	  , false,	 
					          SDL2::EventType::FIRSTEVENT , true
        end
      when Toggle
        not @var.value
      when Bind
        @func.try do 
          @func.call(event)
        end
			end
		end

	end #class EventReg

	#A glorified hash of arrays which hold event registers
	class EventHash

		def initialize()
			@hash = {} of EventTrigger => Array(EventReg)
		end

		#When a event happens
		def on_event_received(event)
      if @hash.has_key?(event.type)
        @hash[event.type].each do |event_reg|
          event_reg.event_action(event)
        end
      end
			if event.type == SDL2::EventType::KEYDOWN || event.type == SDL2::EventType::KEYUP
        if @hash.has_key?(event.key.key_sym.sym)
          @hash[event.key.key_sym.sym].each do |event_reg|
            event_reg.event_action(event)
          end
        end
        if @hash.has_key?(event.key.key_sym.scan_code)
          @hash[event.key.key_sym.scan_code].each do |event_reg|
            event_reg.event_action(event)
		      end
        end
      end
		end

		#Add a event register to the hash
		def add_register(register)
      unless @hash.has_key?(register.event_registered)
        @hash[register.event_registered] = Array(EventReg).new
      end
			@hash[register.event_registered].push(register)
		end
	end

	class App
    #Event handling
    def on_event(event)
      @__event_hash.on_event_received(event)
    end
		#Creates a method which register the signals told
  	macro signal(var,input,event_action)
      {%if event_action.id == "OnOff".id || event_action== "Toggle".id%}
        if @{{variable.id}} == nil
          @{{variable.id}} = false
        end
      {%end%}
  		add_new_signal(pointerof({{var}}),{{input}},{{event_action}})
      
  	end

  	#This function takes information packs them into event registers
  	#   and finally,adds them to the hash
  	def add_new_signal(var, input, event_action)
  		@__event_hash.add_register EventReg.new(event_action,input,var)
  	end

    def signal( input,&block : EventHandler)
      add_new_signal(input, &block)
    end
    def add_new_signal( input, &block : EventHandler)
      @__event_hash.add_register EventReg.new(Bind,input,&block)
    end

  	#This function is meant to be used inside the class definition (but outside a method)
  	#Creates a hidden function which is called by run and does the actual registering
		macro define_signals(*args)
      {%if args.length % 3 != 0%}
        {%raise "Wrong number of arguments"%}
      {%end%}
  			private def __register_signals
  				{%for element,index in args%}
  					{%if index%3 == 0 %}
  						{%variable = element%}
  					{%elsif index%3 == 1 %}
  						{%input = element%}
  					{%else%}
  						{%event_action = element%}
              #Initialize the variable if it must be assigned later
              {%if event_action.id == "OnOff".id || event_action== "Toggle".id%}
                if @{{variable.id}} == nil
                  @{{variable.id}} = false
                end
              {%end%}
  						add_new_signal(pointerof(@{{variable.id}}),{{input}}, {{event_action}} )
  					{%end%}
  				{%end%}
  			end
  		end

	end	
end