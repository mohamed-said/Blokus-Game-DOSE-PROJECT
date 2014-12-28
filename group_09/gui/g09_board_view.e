note
	description: "Summary description for {G09_BOARD_VIEW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_BOARD_VIEW

inherit
	ANY

	KL_SHARED_FILE_SYSTEM
     	export
			{NONE} all
		undefine
			default_create, copy
		end

	G09_GUI_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make_with_world

feature {NONE} -- Implementation

	l_board: ARRAY2[INTEGER]
	l_world: EV_MODEL_WORLD
	l_image: EV_MODEL_PICTURE
	l_pixmap: EV_PIXMAP


	make_with_world(world : EV_MODEL_WORLD)
	do
		l_world := world
		default_create
	end

feature

	set_tile(x,y:INTEGER; color: INTEGER)
	do
		create l_pixmap
		if color = {G09_PLAYER_COLORS}.blue then
			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick("blue", 0)))
			
		elseif color = {G09_PLAYER_COLORS}.yellow then
			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick("yellow", 0)))

		elseif color = {G09_PLAYER_COLORS}.green then
			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick("green", 0)))

		elseif color = {G09_PLAYER_COLORS}.red then
			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick("red", 0)))
		end

		create l_image.make_with_pixmap (l_pixmap)
		l_world. extend(l_image)
		l_image.set_point_position (x * 22, y * 22)
	end

	update_board(board: ARRAY2[INTEGER])
	local
		i, k: INTEGER
	do

		create l_pixmap

		from i := 1	until i > 20 loop

			from k := 1	until k > 20 loop
				l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick("red", 0)))
				create l_image.make_with_pixmap (l_pixmap)
				l_world. extend(l_image)
				l_image.set_point_position (i * 22, k * 22)
				k := k + 1
			end
			i := i + 1
		end

		l_board := board
	end


end
