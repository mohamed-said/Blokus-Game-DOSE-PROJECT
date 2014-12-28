note
	description: "Summary description for {G09_BLOCK_GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_BLOCK_GROUP
inherit
	EV_FIXED

	KL_SHARED_FILE_SYSTEM
     	export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make_with_color

feature {NONE} -- Implementation

	main_window : G09_MAIN_WINDOW
	shader : G09_ACTIVE_PIECE_SHADER

	make_with_color(color: INTEGER; main_ui : G09_MAIN_WINDOW)
	local
		--l_image: EV_MODEL_PICTURE
		l_pixmap: EV_PIXMAP
		brick_color: STRING
	do
		default_create

		main_window := main_ui

		if(color = 1) then
			brick_color := "blue"
		elseif(color = 2) then
			brick_color := "yellow"
		elseif(color = 3) then
			brick_color := "red"
		elseif(color = 4) then
			brick_color := "green"
		end

		create l_pixmap
		l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick_group(brick_color)))

		l_pixmap.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))

		--create l_image.make_with_pixmap (l_pixmap)
		extend (l_pixmap)

		l_pixmap.set_pointer_style (create {EV_POINTER_STYLE}.make_predefined (15))

		l_pixmap.pointer_button_press_actions.extend (agent mouse_click)
	end

	mouse_click(pointer_x, pointer_y, c: INTEGER_32; d, e, f: REAL_64; g,h:INTEGER_32)
	local
		x_square, y_square, block: INTEGER
		temp: REAL_64
	do
		temp := pointer_x / 46
		x_square := temp.floor() + 1;

		temp := pointer_y / 46
		y_square := temp.floor();

		-- five squares per line
		block := y_square * 5 + x_square

		if block = 22
		then
			block := 21
		end

		if block < 22
		then
			main_window.block_selected(block)
		end
	end

	feature

	remove_block(piece_id : INTEGER)
	local
		l_x,l_y : INTEGER
	do
		create shader.make
		extend (shader)

		l_x := ((piece_id-1) \\ 5) * 47
		l_y := ((piece_id / 5 - 1).ceiling) * 47

		if piece_id = 21  then
			shader.set_type (2)
		else
			shader.set_type (1)
		end

		set_item_position (shader, l_x, l_y)
	end

end
