note
	description: "Summary description for {G09_LABEL_HEADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_LABEL_HEADER

inherit
	G09_LABEL

create
	make_with_text_and_type

feature {NONE}

	l_type: INTEGER

	make_with_text_and_type(text: STRING; type: INTEGER)
	do
		default_create

		l_width := 100
		l_height := 50

		create_label
		create_font

		set_text(text)
		set_type(type)

	end

	create_label
	do
		create l_label
		l_label.align_text_left
		l_label.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		l_label.set_foreground_color (create {EV_COLOR}.make_with_8_bit_rgb (255, 255, 255))
		extend_with_position_and_size (l_label, 0, 0, l_width, l_height)
	end

	create_font
	require
		l_labe_is_initialized: l_label.is_initialized
	do
		create l_font
		l_font.set_height (30)
		l_font.set_weight (7)
		l_font.set_family (3)
		l_label.set_font (l_font)
	end

	adjust_size
	do

	end


feature

	set_text(text: STRING)
	do
		l_label.set_text (text)
		adjust_size
	end

	set_type(type: INTEGER)
	do
		if type = 0 then
		elseif type = 1 then

		end

		adjust_size
	end

	enable_mouse_actions
	do
		setup_mouse_events(l_label)
	end

end
