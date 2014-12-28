note
	description: "Summary description for {G09_ACTIVE_PIECE_SHADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"


class
	G09_ACTIVE_PIECE_SHADER

inherit
	EV_FIXED

create
	make

feature {NONE}

	shader_width: INTEGER
	shader_height: INTEGER
	black_box: EV_FIXED

	make
	do
		default_create

		create_black_box

	end

	create_black_box
	do

		create black_box

		black_box.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
		extend_with_position_and_size (black_box, 0, 0, shader_width, shader_height)

	end

feature -- access

	set_type(type: INTEGER)
	do
		if type = 1 then

			shader_width := 45
			shader_height := 47

		elseif type = 2 then

			shader_width := 80
			shader_height := 47

		end

		set_item_size (black_box, shader_width, shader_height)

	end

	get_width : INTEGER
	do
		result := shader_width
	end

end
