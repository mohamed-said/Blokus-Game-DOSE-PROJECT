note
	description: "Summary description for {G09_BUTTON_PIX}."
	author: "Mads Mortensen"
	date: "$Date$"
	revision: "$Revision$"

--	
--	Button stages
--	
--	| default  | 1
--	| over     | 2
--	| down     | 3
--	| inactive | 4
--	

class
	G09_BUTTON_PIX

inherit
	G09_BUTTON

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
	make_with_background

feature {NONE}

	l_background: EV_FIXED
	l_background_pixmap: EV_PIXMAP
	l_width: INTEGER_32
	l_height: INTEGER_32
	l_image_path: STRING
	l_image_pathname: KL_PATHNAME
	l_four_stage: BOOLEAN

	l_get_height: INTEGER_32
	do
		if l_four_stage then
			result := l_height//4
		else
			result := l_height
		end
	end
	l_get_width: INTEGER_32
	do
		result := l_width
	end

	make
	do
		default_create
		create mouse_down_actions
		button_state := "default"

	end

	make_with_background(name: STRING; has_four_stages: BOOLEAN)
	require
		name.count > 0
	do
		l_image_pathname := img_path
		l_image_pathname.append_name (name)
		l_image_path := file_system.pathname_to_string (l_image_pathname)

		l_four_stage := has_four_stages

		make
		make_background

		setup_mouse_events(l_background)
		-- TODO ensure that file exist, is an image etc.

	end

feature {NONE}

	make_background
	require
		file_system.file_exists (l_image_path)
		file_system.is_file_readable (l_image_path)
	do
		create l_background
		create l_background_pixmap
		l_background_pixmap.set_with_named_file (l_image_path)
		l_background.set_background_pixmap (l_background_pixmap)
		extend (l_background)
		adjust_size
	end

	adjust_size
	require
		size_invalid: l_background_pixmap.width > 0 and l_background_pixmap.height > 0
		height_not_dividable_by_four: l_height \\ 4 = 0
	do
		l_width := l_background_pixmap.width
		l_height := l_background_pixmap.height
		l_background.set_minimum_size (l_width, l_height)
		set_minimum_size (l_get_width, l_get_height)
	end

	button_state_over
	do
		if l_four_stage then
			set_item_position (l_background, 0, -l_get_height)
		end
	end

	button_state_default
	do
		if l_four_stage then
			set_item_position (l_background, 0, 0)
		end
	end

	button_state_down
	do
		if l_four_stage then
			set_item_position (l_background, 0, -(l_get_height*2))
		end
	end

	button_state_out
	do
		if l_four_stage then
			button_state_default
		end
	end

	button_state_inactive
	do
		if l_four_stage then
			set_item_position (l_background, 0, -(l_get_height*3))
		end
	end

feature


end
