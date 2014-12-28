note
	description: "Summary description for {G09_LABEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	G09_LABEL

inherit
	EV_FIXED

feature {NONE}
	l_label: EV_LABEL
	l_font: EV_FONT
	l_width: INTEGER
	l_height: INTEGER
	mouse_down_actions: EV_LITE_ACTION_SEQUENCE [TUPLE]
	mouse_events_setup : BOOLEAN

	mouse_down (a, b, c: INTEGER_32; d, e, f: REAL_64; g, h: INTEGER_32)
	do
		mouse_down_actions.call ([0])
	end

	setup_mouse_events (on: EV_WIDGET)
	require
		target_is_initialized: on.is_initialized
	do
		on.pointer_button_press_actions.extend (agent mouse_down)
		mouse_events_setup := true
	end

feature

	set_text(text: STRING)
	deferred
	end

	set_type(type: INTEGER)
	deferred
	end

	set_mouse_down_action (an_agent: PROCEDURE [ANY, TUPLE])
	do
		mouse_down_actions.extend (an_agent)
	end

end
