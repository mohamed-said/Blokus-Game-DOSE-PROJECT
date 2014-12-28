note
	description: "Summary description for {G09_LABEL_SMALL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_LABEL_SMALL


inherit
	G09_LABEL

create
	make_with_text_and_width

feature {NONE}

	l_type: INTEGER

	make_with_text_and_width(text: STRING; new_width: INTEGER)
	do
		default_create

		l_width := new_width
		l_height := 20

		create_label
		create_font

		set_text(text)
		set_type(0)
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
		l_font.set_height (18)
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

	set_label_background_color(color: EV_COLOR)
	do
		l_label.set_background_color(color)
	end

	set_label_foreground_color(color: EV_COLOR)
	do
		l_label.set_foreground_color(color)
	end

	get_text : STRING
	do
		result := l_label.text
	end

end

