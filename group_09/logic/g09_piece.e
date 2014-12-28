note
	description: "Represents a piece that can be placed on the game board in blockus game."
	author: "Mohamed Kamal"
	date: "$Date: 05-11-2013$"
	revision: "$Revision: 1.0$"

class
	G09_PIECE

inherit
	COMPARABLE
		redefine is_equal,is_less end

create
make,
make_with_id,
make_from_piece

feature{NONE} -- Initlization
	make()
	-- Decpreted, will be deleted
	do

	end

	make_with_id(id_m:INTEGER)
	-- ceates a new piece
	local
		row, col:INTEGER
	do
		create piece_arr.make_filled (void, 5, 5)

		from row := 1 until	row > 5
		loop
			from col := 1 until	col > 5
			loop
				piece_arr.put (create {G09_PIECE_POINT}.make_empty, row, col)
				col:=col+1
			end
			row:=row+1
		end

		id := id_m

		if id = 1 then
			--temp_point := create {G09_PIECE_POINT}.make_empty
		    piece_arr.item(3, 2).enable_topleft_top_left

		    piece_arr.item(3, 3).enable_top

		    piece_arr.item(3, 4).enable_topright_top_right

		    piece_arr.item(4, 2).enable_bottomleft_bottom_left

		    piece_arr.item(4, 3).enable_bottomright_bottom_right

		elseif id = 2 then
			piece_arr.item (1, 3).enable_topleft_top_left
			piece_arr.item (1, 4).enable_topright_top_right

			piece_arr.item (2, 3).enable_left_right
			piece_arr.item (3, 3).enable_left_right
			piece_arr.item (4, 3).enable_left_right

		elseif id = 3 then
			piece_arr.item (3, 3).enable_topleft_top_left
			piece_arr.item (3, 4).enable_topright_top_right


			piece_arr.item (4, 3).enable_bottomleft_bottom_left
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 4 then
			piece_arr.item (3, 3).enable_topleft_top_left
			piece_arr.item (3, 3).enable_topright_top_right
			piece_arr.item (3, 3).enable_bottomleft_bottom_left
			piece_arr.item (3, 3).enable_bottomright_bottom_right

		elseif id = 5 then
			piece_arr.item (2, 2).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_bottomleft_bottom_left
			piece_arr.item (3, 4).enable_bottomright_bottom_right

			piece_arr.item (4, 4).enable_bottomleft_bottom_left
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 6 then
			piece_arr.item (3, 2).enable_topleft_top_left
			piece_arr.item (3, 3).enable_top
			piece_arr.item (3, 4).enable_topright_top_right

			piece_arr.item (4, 2).enable_bottomleft_bottom_left
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 7 then

			piece_arr.item (2, 2).enable_topleft_top_left
			piece_arr.item (3, 2).enable_left

			piece_arr.item (4, 2).enable_bottomleft_bottom_left
			piece_arr.item (4, 2).enable_bottomright_bottom_right

			piece_arr.item (3, 3).enable_top_bottom

			piece_arr.item (3, 4).enable_topright_top_right
			piece_arr.item (3, 4).enable_bottomright_bottom_right

		elseif id = 8 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_topleft_top_left
			piece_arr.item (3, 3).enable_bottomright_bottom_right

			piece_arr.item (4, 3).enable_bottomleft_bottom_left
			piece_arr.item (4, 3).enable_bottomright_bottom_right

			piece_arr.item (3, 4).enable_left_right


		elseif id = 9 then

			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_bottomleft_bottom_left
			piece_arr.item (3, 3).enable_bottomright_bottom_right

		elseif id = 10 then
			piece_arr.item (3, 2).enable_topleft_top_left
			piece_arr.item (3, 2).enable_bottomleft_bottom_left

			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_bottom

			piece_arr.item (3, 4).enable_topright_top_right

			piece_arr.item (4, 4).enable_bottomleft_bottom_left
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 11 then
			piece_arr.item (3, 3).enable_topleft_top_left
			piece_arr.item (4, 3).enable_left
			piece_arr.item (5, 3).enable_bottomleft_bottom_left

			piece_arr.item (3, 4).enable_top_bottom

			piece_arr.item (3, 5).enable_topright_top_right
			piece_arr.item (3, 5).enable_bottomright_bottom_right

		elseif id = 12 then
			piece_arr.item (1, 3).enable_topleft_top_left
			piece_arr.item (1, 3).enable_topright_top_right
			piece_arr.item (2, 3).enable_left_right
			piece_arr.item (3, 3).enable_left_right
			piece_arr.item (4, 3).enable_left_right
			piece_arr.item (5, 3).enable_bottomleft_bottom_left
			piece_arr.item (5, 3).enable_bottomright_bottom_right

		elseif id = 13 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 2).enable_topleft_top_left
			piece_arr.item (3, 2).enable_bottomright_bottom_right

			piece_arr.item (3, 3).enable_bottomright_bottom_right

		elseif id = 14 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 2).enable_topleft_top_left
			piece_arr.item (3, 2).enable_bottomleft_bottom_left

			piece_arr.item (4, 3).enable_bottomleft_bottom_left
			piece_arr.item (4, 3).enable_bottomright_bottom_right

			piece_arr.item (3, 4).enable_topright_top_right
			piece_arr.item (3, 4).enable_bottomright_bottom_right

			piece_arr.item (3, 3).enable_inner_brick

		elseif id = 15 then
			piece_arr.item (2, 2).enable_topleft_top_left
			piece_arr.item (2, 2).enable_topright_top_right
			piece_arr.item (3, 2).enable_bottomleft_bottom_left

			piece_arr.item (3, 3).enable_topright_top_right
			piece_arr.item (4, 3).enable_left_right

			piece_arr.item (5, 3).enable_bottomleft_bottom_left
			piece_arr.item (5, 3).enable_bottomright_bottom_right

		elseif id = 16 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_left_right

			piece_arr.item (4, 4).enable_topright_top_right
			piece_arr.item (4, 4).enable_bottomright_bottom_right
			piece_arr.item (4, 3).enable_topright_top_right
			piece_arr.item (4, 3).enable_bottomright_bottom_right


		elseif id = 17 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (2, 3).enable_bottomleft_bottom_left
			piece_arr.item (4, 3).enable_bottomright_bottom_right

			piece_arr.item (3, 3).enable_left_right

		elseif id = 18 then
			piece_arr.item (2, 2).enable_topleft_top_left
			piece_arr.item (2, 2).enable_bottomleft_bottom_left

			piece_arr.item (2, 3).enable_topleft_top_left

			piece_arr.item (3, 3).enable_left_right

			piece_arr.item (4, 3).enable_bottomleft_bottom_left

			piece_arr.item (4, 4).enable_topright_top_right
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 19 then
			piece_arr.item (2, 3).enable_topleft_top_left
			piece_arr.item (2, 3).enable_topright_top_right

			piece_arr.item (3, 3).enable_bottomright_bottom_right

			piece_arr.item (3, 4).enable_topright_top_right

			piece_arr.item (4, 4).enable_bottomleft_bottom_left
			piece_arr.item (4, 4).enable_bottomright_bottom_right

		elseif id = 20 then
			piece_arr.item (1, 3).enable_topleft_top_left
			piece_arr.item (1, 3).enable_topright_top_right

			piece_arr.item (2, 3).enable_left
			piece_arr.item (3, 3).enable_left_right

			piece_arr.item (4, 3).enable_left_right

			piece_arr.item (2, 4).enable_topright_top_right
			piece_arr.item (2, 4).enable_bottomright_bottom_right

		elseif id = 21 then
			piece_arr.item (3, 1).enable_topleft_top_left
			piece_arr.item (3, 1).enable_bottomleft_bottom_left

			piece_arr.item (3, 2).enable_top_bottom
			piece_arr.item (3, 3).enable_top_bottom
			piece_arr.item (3, 4).enable_top_bottom

		end

		move_to_top_left()		-- pieces are by default in the center of the array, calling this makes to the topleft
		blocks_no := calc_blocks_no
		create board_pos.make_fromxy (0, 0)
	end

feature{NONE}
	update_after_rotation_clock
	local
		i:INTEGER
		array_local:ARRAY[G09_POINT]
	do
		array_local := get_points

		from i:= array_local.lower until i>array_local.upper
		loop
			if array_local.item (i) /= void then
				current.get_brick_at (array_local.item (i).get_x, array_local.item (i).get_y).rotate_clockwise
			end
			i:=i+1
		end
	end

	update_after_rotation_anti
	local
		i:INTEGER
		array_local:ARRAY[G09_POINT]
	do
		array_local := get_points

		from i:= array_local.lower until i>array_local.upper
		loop
			if array_local.item (i) /= void then
				current.get_brick_at (array_local.item (i).get_x, array_local.item (i).get_y).rotate_anticlockwise
			end
			i:=i+1
		end
	end

	calc_blocks_no():INTEGER
	local
		row, col:INTEGER
	do
		result:=0
		from col := 1 until col > 5 loop
			from row := 1 until row > 5
			loop
				if not piece_arr.item (row, col).empty then
					result:=result+1
				end
				row := row + 1
			end

			col := col + 1
		end
	end

	move_to_top_left
	local
		row, col:INTEGER
		min_point:G09_POINT
		new_arr:ARRAY2[G09_PIECE_POINT]
	do
		create new_arr.make_filled (create {G09_PIECE_POINT}.make_empty, 5, 5)
		min_point := get_min_x_y.deep_twin

		from col := min_point.get_x until col > 5 loop
			from row := min_point.get_y until row > 5
			loop
				new_arr.put  (piece_arr.item (row, col), row - min_point.get_y + 1, col - min_point.get_x + 1)
				row := row + 1
			end

			col := col + 1
		end
		piece_arr := new_arr
	end

	get_min_x_y():G09_POINT
	local
		row, col:INTEGER
	do
		create Result.make_fromxy (6, 6)
		from col := 1 until col > 5 loop
			from row := 1 until row > 5
			loop
				if not piece_arr.item (row, col).empty then
					if row < Result.get_y then
						Result.set_y (row.deep_twin)
					end

					if col < Result.get_x then
						Result.set_x (col.deep_twin)
					end
				end

				row := row + 1
			end

			col := col + 1
		end
	end

	get_max_x_y():G09_POINT
	local
		row, col:INTEGER
	do
		create Result.make_fromxy (0, 0)
		from col := 1 until col > 5 loop
			from row := 1 until row > 5
			loop
				if not piece_arr.item (row, col).empty then
					if row > Result.get_y then
						Result.set_y (row.deep_twin)
					end

					if col > Result.get_x then
						Result.set_x (col.deep_twin)
					end
				end

				row := row + 1
			end

			col := col + 1
		end
	end

	make_from_piece(piece:G09_PIECE)
	-- Depreacted
	do

	end
feature
	is_equal(other:like Current): BOOLEAN
	do
		result:= get_id = other.get_id
	end

	is_less alias "<" (other: like Current): BOOLEAN
	do
		result:= get_id < other.get_id
	end

feature -- Access
	get_id():INTEGER
	do
		result:=id
	end

	get_points():ARRAY[G09_POINT]
	-- returns the piece as an array of points
	local
		col, row, new_index:INTEGER
	do
		create result.make_filled (void, 0, 25)
		new_index := 0

		from col := 1 until col > 5
		loop
			from row := 1 until row > 5
			loop
				if not piece_arr.item (row, col).empty then
					result.put (create {G09_POINT}.make_fromxy (row, col), new_index)
					new_index := new_index+1
				end

				row := row + 1
			end

			col := col + 1
		end
	end

	get_points_on_board():ARRAY[G09_POINT]
	-- returns the piece as an array of points relative to the board position
	local
		i:INTEGER
	do
		Result := get_points()
		from i := Result.lower until i > Result.upper loop
			if result.item(i) /= void then
				result.item(i).set_x(result.item(i).get_x + get_board_position.get_x - 1)
				result.item(i).set_y(result.item(i).get_y + get_board_position.get_y - 1)
		end

			i := i + 1
		end
	end

	set_board_position(pos:G09_POINT)
	do
		board_pos := pos.deep_twin
	end

	get_board_position():G09_POINT
	do
		result:=board_pos
	end

	calculate_width():INTEGER
	-- calculate the width of the piece that the points form
	do
		result:= get_max_x_y.get_x - get_min_x_y.get_x + 1
	end

	calculate_height():INTEGER
	-- calculate the height of the piece that the points form
	do
		result:= get_max_x_y.get_y - get_min_x_y.get_y + 1
	end

	get_blocks_number():INTEGER
	do
		result := blocks_no
	end

	get_brick_at(row, col:INTEGER):G09_PIECE_POINT
	do
		result:=piece_arr.item (row, col)
	end

	get_played():BOOLEAN
	do
		result := was_played
	end

	set_played(value:BOOLEAN)
	do
		was_played := value
	end

feature -- Piece operations
	revert_to_original_position()
	-- rever the piece to its origianl position without any rotations/flipping, applied inside the piece and raises the event bricks changed
	do
		make_with_id (get_id())
	end

	rotate_clockwise()
	-- rotates the current piece clockwise, applied inside the piece and raises the event bricks changed
	local
		col, row:INTEGER
		rotated_piece_arr:ARRAY2[G09_PIECE_POINT]
	do
		create rotated_piece_arr.make_filled (void , 5, 5)
		from col := 1 until col > 5
		loop
			from row := 1 until row > 5
			loop
				rotated_piece_arr.put (piece_arr.item (row, col), col, 6 - row)

				row := row + 1
			end

			col := col + 1
		end
		piece_arr := rotated_piece_arr
		move_to_top_left
		update_after_rotation_clock
	end

	rotate_anticlockwise()
	-- rotates the current piece anticlockwise, applied inside the piece and raises the event bricks changed
	local
		col, row:INTEGER
		rotated_piece_arr:ARRAY2[G09_PIECE_POINT]
	do
		create rotated_piece_arr.make_filled (void, 5, 5)
		from col := 1 until col > 5
		loop
			from row := 1 until row > 5
			loop
				rotated_piece_arr.put (piece_arr.item (row, col), col, row)

				row := row + 1
			end

			col := col + 1
		end

		piece_arr := rotated_piece_arr
		move_to_top_left
		update_after_rotation_anti
	end

	flip_horizontal()
	-- flip the current piece vertically, applied inside the piece and raises the event bricks changed
	local
		col, row:INTEGER
		temp:G09_PIECE_POINT
	do
		from col := 1 until col > 2
		loop
			from row := 1 until row > 2
			loop
				temp := piece_arr.item (row, col)
				piece_arr.put (piece_arr.item (row, 6 - col), row, col)
				piece_arr.put (temp, row, 6 - col)

				row := row+1
			end

			col := col+1
		end
	end

	flip_vertical()
	-- flip the current piece vertically, applied inside the piece and raises the event bricks changed
	local
		col, row:INTEGER
		temp:G09_PIECE_POINT
	do
		from col := 1 until col = 3
		loop
			from row := 1 until row = 3
			loop
				temp := piece_arr.item (row, col)
				piece_arr.put (piece_arr.item (6 - row, col), row, col)
				piece_arr.put (temp, 6 - row, col)

				row := row+1
			end

			col := col+1
		end
	end

	is_symtrical_horizontal():BOOLEAN
	do
		result:=symtric_hori
	end

	is_symtrical_vertical():BOOLEAN
	do
		result:=symtric_vert
	end

feature{NONE} -- Implementation
	piece_arr:ARRAY2[G09_PIECE_POINT]
	id:INTEGER
	symtric_hori:BOOLEAN
	symtric_vert:BOOLEAN
	blocks_no:INTEGER
	was_played:BOOLEAN
	board_pos:G09_POINT
end
