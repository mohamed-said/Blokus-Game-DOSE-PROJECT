note
	description: "Summary description for {G09_BUTTON_GREEN}."
	author: "Mads Mortensen"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_BUTTON_GREEN


inherit
	G09_BUTTON

create
	make_with_text,
	make_with_text_and_width

feature {NONE}

	l_background: EV_FIXED
	l_width: INTEGER_32
	l_height: INTEGER_32
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
		l_height := 40
		l_width := 150
		make
		set_text(text)
	end

	make_with_text_and_width(text: STRING; text_width:INTEGER)
	do
		l_height := 40
		l_width := text_width
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
		l_textfield.align_text_left

		create l_font
		l_font.set_height (30)
		l_font.set_weight (7)
		l_font.set_family (3)
		l_textfield.set_font (l_font)
		extend_with_position_and_size(l_textfield, 0, 0, l_width, l_height)
	end

	button_state_over
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (72,153,95))
	end

	button_state_default
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
	end

	button_state_down
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (141,192,163))
	end

	button_state_out
	do
		button_state_default
	end

	button_state_inactive
	do
		l_textfield.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (140,140,140))
	end

feature

	set_text (text: STRING)
	do
		l_textfield.set_text (text)
	end

	get_text() : STRING
	do
		Result := l_textfield.text
	end

end
