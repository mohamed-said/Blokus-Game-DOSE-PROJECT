note
	description: "Summary description for {G09_IMAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_IMAGE

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
	make

feature {NONE}

	l_width: INTEGER
	l_height: INTEGER
	l_image_path: STRING
	l_image_pathname: KL_PATHNAME

	make(name: STRING)
	do
		default_create

		l_image_pathname := img_path
		l_image_pathname.append_name (name)
		l_image_path := file_system.pathname_to_string (l_image_pathname)

		create_image_pixmap

	end

	create_image_pixmap
	require
		file_exists: file_system.file_exists (l_image_path)
		file_is_readable: file_system.is_file_readable (l_image_path)
	do
		create pixmap
		pixmap.set_with_named_file (l_image_path)
		set_background_pixmap (pixmap)
		adjust_size
	end

	adjust_size
	do
		l_width := pixmap.width
		l_height := pixmap.height
		set_minimum_size (l_height, l_width)
	end

feature
	pixmap: EV_PIXMAP

end
