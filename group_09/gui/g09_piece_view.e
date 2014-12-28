note
	description: "Summary description for {G09_SQUARE}."
	author: "Mikael Hardø"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_PIECE_VIEW

inherit
	EV_MODEL_MOVE_HANDLE

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
	make_with_color

feature {ANY} -- Implementation
	make_with_color(color: INTEGER; points : ARRAY[G09_POINT])
		local
			l_image: EV_MODEL_PICTURE
			l_pixmap: EV_PIXMAP
			i: INTEGER
			l_point : G09_POINT
		do
			default_create
			is_valid := true

			create images.make_filled (Void, 0, 25)

			create l_pixmap

			if(color = 1) then
				brick_color := "blue"
			elseif(color = 2) then
				brick_color := "yellow"
			elseif(color = 3) then
				brick_color := "red"
			elseif(color = 4) then
				brick_color := "green"
			end

			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick(brick_color, 1)))

--			if brick = 1 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 2)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--			end

--			if brick = 2 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--				brick_array.put (true, 9)
--			end

--			if brick = 3 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--			end

--			if brick = 4 then
--				brick_array.put (true, 0)
--			end

--			if brick = 5 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 4)
--				brick_array.put (true, 5)
--				brick_array.put (true, 8)
--			end

--			if brick = 6 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 2)
--				brick_array.put (true, 3)
--				brick_array.put (true, 5)
--			end

--			if brick = 7 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 5)
--				brick_array.put (true, 6)
--			end

--			if brick = 8 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 6)
--			end

--			if brick = 9 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--			end

--			if brick = 10 then
--				brick_array.put (true, 1)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 5)
--				brick_array.put (true, 8)
--			end

--			if brick = 11 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 2)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--			end

--			if brick = 12 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--				brick_array.put (true, 9)
--			end

--			if brick = 13 then
--				brick_array.put (true, 1)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--			end

--			if brick = 14 then
--				brick_array.put (true, 1)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 5)
--				brick_array.put (true, 7)
--			end

--			if brick = 15 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 7)
--				brick_array.put (true, 10)
--			end

--			if brick = 16 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--				brick_array.put (true, 7)
--			end

--			if brick = 17 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--			end

--			if brick = 18 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 1)
--				brick_array.put (true, 4)
--				brick_array.put (true, 7)
--				brick_array.put (true, 8)
--			end

--			if brick = 19 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 7)
--			end

--			if brick = 20 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 4)
--				brick_array.put (true, 6)
--				brick_array.put (true, 9)
--			end

--			if brick = 21 then
--				brick_array.put (true, 0)
--				brick_array.put (true, 3)
--				brick_array.put (true, 6)
--				brick_array.put (true, 9)
--				brick_array.put (true, 12)
--			end

			from i := 0	until i > 25 loop
				if points[i] /= Void then
					l_point := points[i]
					create l_image.make_with_pixmap (l_pixmap)
					extend(l_image)
					l_image.set_point_position ((l_point.get_x) * 22, (l_point.get_y) * 22)
					--l_image.set_point_position ((i \\ 3) * 22, (i / 3).floor * 22)
					images.put (l_image, i)
				end
				i := i + 1
			end

			disable_moving
			enable_rotating

			enable_move
			enable_events_sended_to_group
		end

	update_points(points : ARRAY[G09_POINT])
	local
		i: INTEGER
	do
		i:=0
		from Current.start	until Current.after loop
			if points[i] /= Void then
				if attached {EV_MODEL_PICTURE} Current.item as image then
					image.set_point_position ((points[i].get_x - 1) * 22, (points[i].get_y - 1) * 22)
				end
				i := i + 1
			end
			Current.forth
		end
	end

feature -- Status setting

	enable_move
		do
--			pointer_motion_actions.extend(agent on_pointer_motion_on_world)
--			pointer_button_press_actions.extend(agent on_pointer_button_press_on_world)
--			pointer_button_release_actions.extend(agent on_pointer_button_release_on_world)
		end

--	get_covered_squares
--	local
--		x_square, y_square: INTEGER
--		temp: REAL_64
--		squares: SPECIAL[EV_MODEL]
--		square : EV_MODEL
--		i: INTEGER
--	do
--		squares := current.area

--		from i := 0	until i >= squares.to_array.count loop
--			square := squares.item (i)

--			-- square size is 22x22
--			temp := square.x / 22
--			x_square := temp.floor() + 1
--			temp := square.y / 22
--			y_square := temp.floor() + 1

--			--print(x_square.out + "," + y_square.out + "%N")

--			i := i + 1
--		end
--	end

--	rotate_block(degrees: INTEGER)
--	local
--		x_square, y_square, x_rotate, y_rotate, l_x, l_y: INTEGER_32
--		l_angle: REAL_64
--		square : EV_MODEL_PICTURE
--		l_center_x, l_center_y, i : INTEGER_32
--		math : DOUBLE_MATH
--		l_offset_x, l_offset_y: INTEGER_32

--	do
--		create math

--		l_angle := (math.pi/180) * degrees

--		l_center_x := 55
--		l_center_y := 55

--		-- very large number (should never become more than 110)
--		l_offset_x := 99999999
--		l_offset_y := 99999999

--		from i := 0	until i >= images.count loop
--			square := images.item (i)

--			if square /= Void then
--				x_square := square.point_x_relative + l_center_x;
--				y_square := square.point_x_relative + l_center_x;

--				x_rotate := (math.cosine (l_angle) * (square.point_x_relative - l_center_x) - math.sine (l_angle) * (square.point_y_relative - l_center_x) + l_center_x).floor
--				y_rotate := (math.sine (l_angle) * (square.point_x_relative - l_center_x) + math.cosine (l_angle) * (square.point_y_relative - l_center_x) + l_center_x).floor

--				if x_rotate < l_offset_x then
--					l_offset_x := x_rotate
--				end

--				if y_rotate < l_offset_y then
--					l_offset_y := y_rotate
--				end

--				square.set_point_position_relative (x_rotate, y_rotate)
--			end

--			i := i + 1
--		end

--		from i := 0	until i >= images.count loop
--			square := images.item (i)

--			if square /= Void then
--				square.set_point_position_relative (square.point_x_relative - l_offset_x, square.point_y_relative - l_offset_y)
--			end

--			i := i + 1
--		end

--		l_x := point_x
--		l_y := point_y

--		if l_x < 0
--		then
--			l_x := 0
--		end

--		if l_y < 0
--		then
--			l_y := 0
--		end

--		if l_x > board_width-bounding_box.width
--		then
--			l_x := board_width-bounding_box.width
--		end

--		if l_y > board_width-bounding_box.height
--		then
--			l_y := board_width-bounding_box.height
--		end

--		set_point_position (l_x, l_y)

--	end

	is_valid : BOOLEAN

	update_validity(l_is_valid : BOOLEAN)
	local
		square : EV_MODEL_PICTURE
		i : INTEGER
		l_pixmap : EV_PIXMAP
		l_state: INTEGER
	do
		if l_is_valid /= is_valid then
			is_valid := l_is_valid

			if l_is_valid then
				l_state := 1
			else
				l_state := 2
			end

			create l_pixmap
			l_pixmap.set_with_named_file (file_system.pathname_to_string (img_brick(brick_color, l_state)))

			from i := 0	until i >= images.count loop
				square := images.item (i)

				if square /= Void then
					square.set_pixmap (l_pixmap)
				end

				i := i + 1
			end
		end
	end



feature -- Move features

	board_width: INTEGER_32 = 440
	drag_offset_x, drag_offset_y: INTEGER
	images : ARRAY[EV_MODEL_PICTURE]
	brick_color : STRING
	is_dragging : BOOLEAN

	set_is_dragging(to: BOOLEAN)
	do
		is_dragging := to
	end

	get_x : INTEGER
	do
		Result :=	Current.point_x_relative // 22 + 1
	end

	get_y : INTEGER
	do
		Result :=	Current.point_y_relative // 22 + 1
	end

--get_logic_piece : G09_PIECE
--	local
--		x_square, y_square: INTEGER
--		temp: REAL_64
--		squares: SPECIAL[EV_MODEL]
--		square : EV_MODEL
--		i: INTEGER
--		piece : G09_PIECE
--		points : ARRAY[G09_POINT]
--		l_point : G09_POINT
--	do
--			create points.make_filled (Void, 0, images.count - 1)

--			from i := 0	until i >= images.count loop
--				square := images.item (i)

--				-- square size is 22x22
--				temp := square.x / 22
--				x_square := temp.floor() + 1
--				temp := square.y / 22
--				y_square := temp.floor() + 1

--				create l_point.make_fromxy (x_square, y_square)
--				points.put (l_point, i)

--				i := i + 1
--			end

--		create piece.make
--		--piece.set_points(points)

--		Result := piece
--	end

	on_pointer_motion_on_world(ax, ay: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
	local
		l_x: INTEGER
		l_y: INTEGER
	do

		if is_dragging then
			l_x :=  ax - drag_offset_x
			l_y := ay - drag_offset_y

			if l_x < 0
			then
				l_x := 0
			end

			if l_y < 0
			then
				l_y := 0
			end

			if l_x > board_width-bounding_box.width
			then
				l_x := board_width-bounding_box.width
			end

			if l_y > board_width-bounding_box.height
			then
				l_y := board_width-bounding_box.height
			end

 			set_point_position(l_x, l_y)

 		end
	end

	on_pointer_button_press_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		do
			if not is_dragging then
				--enable_capture
				is_dragging := true
				drag_offset_x := ax - point_x
				drag_offset_y := ay - point_y
			end
		end

	on_pointer_button_release_on_world (ax, ay, button: INTEGER; x_tilt, y_tilt, pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER)
		local
			modo: INTEGER
			l_x, l_y : INTEGER
		do
			if is_dragging then

				modo := point_x \\ 22

				if modo < 11 then
					l_x := point_x - modo
				else
					l_x := point_x + (22 - modo)
				end

				modo := point_y \\ 22

				if modo < 11 then
					l_y := point_y - modo
				else
					l_y := point_y + (22 - modo)
				end

				if l_y < 0 then
					l_y := 0
				end

				if l_x < 0 then
					l_x := 0
				end

				if l_x > board_width-bounding_box.width
				then
					l_x := board_width-bounding_box.width
				end

				if l_y > board_width-bounding_box.height
				then
					l_y := board_width-bounding_box.height
				end

				current.set_point_position(l_x, l_y)

				if is_dragging then
					is_dragging := false
				end
			end
		end

end
