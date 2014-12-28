note
	description: "Summary description for {G09_BUTTON_STANDARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_BUTTON_STANDARD

inherit
	G09_BUTTON

create
	make_with_text

feature {NONE}

	l_background: EV_FIXED
	l_width: INTEGER_32 = 200
	l_height: INTEGER_32 = 30
	l_border_width: INTEGER_32
	l_font: EV_FONT
	l_textfield: EV_LABEL

	make
	do
		default_create
		create mouse_down_actions
		button_state := "default"

		make_background
		make_textfield

		setup_mouse_events(l_textfield)

	end

	make_with_text(text: STRING)
	do
		make
		set_text(text)

	end

feature {NONE}

	make_background
	do
		create l_background
		l_background.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		extend_with_position_and_size (l_background, 0, 0, l_width, l_height)
	end

	make_textfield
	do
		create l_textfield
		l_textfield.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))

		create l_font
		l_font.set_height (15)
		l_font.set_family (3)
		l_textfield.set_font (l_font)
		l_border_width := 3
		extend_with_position_and_size(l_textfield, l_border_width, l_border_width, l_width-(2*l_border_width), l_height-(2*l_border_width))
	end

	button_state_over
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		l_textfield.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (100, 100, 100))
		l_background.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
	end

	button_state_default
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		l_textfield.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		l_background.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
	end

	button_state_down
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		l_textfield.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (200, 200, 200))
		l_background.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
	end

	button_state_out
	do
		button_state_default
	end

	button_state_inactive
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (140, 140, 140))
		l_textfield.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		l_background.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (140, 140, 140))
	end

feature

	set_text (text: STRING)
	do
		l_textfield.set_text (text)
	end

end
