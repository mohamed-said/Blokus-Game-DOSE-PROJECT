note
	description: "Summary description for {G09_BUTTON}."
	author: "Mads Mortensen"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	G09_BUTTON

inherit
	EV_FIXED

feature {NONE}

	mouse_down_actions: EV_LITE_ACTION_SEQUENCE [TUPLE]
	mouse_events_setup: BOOLEAN
	button_state: STRING_8
	inactive: BOOLEAN
	mouse_event_target: EV_WIDGET
	default_cursor_style: INTEGER

	mouse_down (a, b, c: INTEGER_32; d, e, f: REAL_64; g, h: INTEGER_32)
	do
		if not inactive then
			button_state := "down"
			button_state_down
		end
	end

	mouse_release (a, b, c: INTEGER_32; d, e, f: REAL_64; g, h: INTEGER_32)
	do
		if not inactive then
			button_state := "default"
			button_state_over
			mouse_down_actions.call ([0])
		end
	end

	mouse_enter
	do
		if not inactive then
			button_state := "over"
			button_state_over
		end
	end

	mouse_leave
	do
		if not inactive then
			button_state := "out"
			button_state_out
		end
	end

	button_state_over
	deferred
	end

	button_state_default
	deferred
	end

	button_state_down
	deferred
	end

	button_state_out
	deferred
	end

	button_state_inactive
	deferred
	end

	setup_mouse_events (on: EV_WIDGET)
	require
		target_is_initialized: on.is_initialized
	do
		default_cursor_style := 15
		mouse_event_target := on
		mouse_event_target.pointer_button_press_actions.extend (agent mouse_down)
		mouse_event_target.pointer_button_release_actions.extend (agent mouse_release)
		mouse_event_target.pointer_enter_actions.extend (agent mouse_enter)
		mouse_event_target.pointer_leave_actions.extend (agent mouse_leave)
		mouse_event_target.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (default_cursor_style))
		mouse_events_setup := true
	end

feature -- access

	set_mouse_down_action (an_agent: PROCEDURE [ANY, TUPLE])
	require
		target_is_setup: mouse_events_setup
		target_is_callable: an_agent.callable
	do
		mouse_down_actions.extend (an_agent)
	ensure
		mouse_down_actions_amount_is_valid: mouse_down_actions.count > 0 and mouse_down_actions.count < 10
	end

	set_inactive
	do
		if not inactive then
			inactive := true
			button_state_inactive
			mouse_event_target.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (2))
		end
	end

	set_active
	do
		if inactive then
			inactive := false
			button_state_default
			mouse_event_target.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (default_cursor_style))
		end
	end

	is_inactive : BOOLEAN
	do
		result := inactive
	end

	toggle_inactive
	do
		if inactive then
			set_active
		else
			set_inactive
		end
	end

	set_hover_cursor_type(cursor_style: INTEGER)
	do
		default_cursor_style := cursor_style
		mouse_event_target.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (default_cursor_style))
	end

end -- class G09_BUTTON

