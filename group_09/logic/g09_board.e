note
	description: "Represents the game board for blockus game."
	author: "Mohamed Said, Mohamed Kamal"
	date: "$Date: 06-12-2013$"
	revision: "$Revision: 1.0$"

class
	G09_BOARD

create
make

feature{NONE} -- Initlization
	make
	do
		create color_of_square_color_changed.make
		create score_of_color_changed.make

		create board.make_filled ({G09_PLAYER_COLORS}.empty, 20, 20)
		create color_scores.make_filled({G09_PLAYER_COLORS}.start_score, {G09_PLAYER_COLORS}.blue, {G09_PLAYER_COLORS}.green)
	end -- make

feature -- Open API
	can_add_piece(X:INTEGER; Y:INTEGER; piece:G09_PIECE; color_id:INTEGER): INTEGER
	-- Deperacted: use add_game_piece(piece, color_id) with board points inside the piece using piece.set_board_position
	-- this feature now is a wrapper to add_piece_new
	do
		piece.get_board_position.set_x(X)
		piece.get_board_position.set_y(Y)

		result := can_add_game_piece(piece, color_id)
	end

	can_add_game_piece(piece:G09_PIECE; color_id:INTEGER): INTEGER
	-- checks if this piece can be added to the board using it board coordinates
	-- return the score of the color on the board if this piece was added
	local
	    X, Y:INTEGER
	do
		result:=0

	    X := piece.get_board_position().get_x
	    Y := piece.get_board_position().get_y

		-- The first piece played of each color is placed in one of the board's four corners.

		-- Each new piece played must be placed so that it touches at least one piece of the same color
		-- with only corner-to-corner contact allowed-edges cannot touch.
		-- However, edge-to-edge contact is allowed when two pieces of different color are involved.

		--if piece not over another piece then

		--end
		if is_piece_overlap_another_color (piece) then
			result := -1

		elseif is_color_first_play_on_board(color_id) then
			if not is_piece_on_board_corners(piece) then
				result := -1
			end

		elseif not is_piece_touch_surrounding_colors_correctly(piece, color_id) then
			result := -1
		end

		if result /= -1 then
			Result := get_score_of_color (color_id) + piece.get_blocks_number()
		end

		if Result = {G09_PLAYER_COLORS}.final_score then
			if piece.get_blocks_number = 1 then		-- is monomino
				Result := Result + 20
			else
				Result := Result + 15
			end
		end
	end -- can_add_piece

feature{G09_GAME, G09_TEST_BOARD} -- Updating board status
	add_piece(X:INTEGER; Y:INTEGER; piece:G09_PIECE; color_id:INTEGER)
	-- Deperacted: use can_add_game_piece(piece, color_id) with board points inside the piece using piece.set_board_position
	-- this feature now is a wrapper to add_game_piece
	do
		piece.get_board_position.set_x(X)
		piece.get_board_position.set_y(Y)

		add_game_piece(piece, color_id)
	end

	add_game_piece(piece:G09_PIECE; color_id:INTEGER)
	-- add the piece to the board using it board coordinates
	local
		i:INTEGER
		array:ARRAY[G09_POINT]
	do
	    array := piece.get_points_on_board()

--	    print ("Adding piece to the board, Color: " + color_id + "%N")

	    from i := array.lower until i > array.upper loop

	    	if array[i] /= void then
--	    		print("Piece point: " + array.item(i).get_x + " " + array.item(i).get_y + "%N")
	    		set_color_at(array.item(i).get_x - 1, array.item(i).get_y - 1, color_id)
	    	end

			i:=i+1
	    end

		if get_score_of_color(color_id) = {G09_PLAYER_COLORS}.final_score then
			if piece.get_blocks_number = 1 then		-- is monomino
				increment_score_of_color(color_id, 20)
			else
				increment_score_of_color(color_id, 15)
			end
		end
	end

feature{NONE} -- Status queries

	is_color_first_play_on_board(color:INTEGER):BOOLEAN
	do
		result := color_scores[color] = {G09_PLAYER_COLORS}.start_score
	end

	is_piece_on_board_corners(piece:G09_PIECE):BOOLEAN
	do
		result:= is_piece_on_board_topleft_corner(piece) or
				 is_piece_on_board_topright_corner(piece) or
				 is_piece_on_board_bottomleft_corner(piece) or
				 is_piece_on_board_bottomright_corner(piece)
	end

	is_piece_on_board_topleft_corner(piece:G09_PIECE):BOOLEAN
	do
		if piece.get_board_position.get_x = 1 and piece.get_board_position.get_y = 1 then
			result := true
		end
	end

	is_piece_on_board_topright_corner(piece:G09_PIECE):BOOLEAN
	do
		--print("calculation: ") print (piece.calculate_width) print (piece.calculate_height)
		if piece.get_board_position.get_x = 20 - piece.calculate_height + 1 and piece.get_board_position.get_y = 1 then
			result := true
		end
	end

	is_piece_on_board_bottomleft_corner(piece:G09_PIECE):BOOLEAN
	do
		if piece.get_board_position.get_x = 1 and piece.get_board_position.get_y = 20 - piece.calculate_width + 1 then
			result := true
		end
	end

	is_piece_on_board_bottomright_corner(piece:G09_PIECE):BOOLEAN
	do
		if piece.get_board_position.get_x =  20 - piece.calculate_height + 1 and piece.get_board_position.get_y = 20 - piece.calculate_width + 1 then
			result := true
		end
	end

	is_piece_overlap_another_color(piece:G09_PIECE):BOOLEAN
	local
		i:INTEGER
		array:ARRAY[G09_POINT]
	do
		-- assume no overlapping happens
		result := false
	    array := piece.get_points_on_board()
	    from i := array.lower until i > array.upper or result loop

	    	if array[i] /= void then
	    		if get_color_at (array.item (i).get_x, array.item (i).get_y) /= {G09_PLAYER_COLORS}.empty then
	    			-- if color at a square will be placed on a non empty place, then overlapping happens
	    			result := true
	    		end
	    	end
	    	i:=i+1
	    end
	end

	is_piece_square_touch_correct_edges(X, Y:INTEGER ;piece_point:G09_PIECE_POINT; color_id:INTEGER) : BOOLEAN
	-- check if this piece square touch adjacement edges of different colors only
	do
		-- assume that the piece touches edges of different colors
		result := true

		if
			( piece_point.top and
			  get_color_at(X - 1, Y) = color_id ) or

			( piece_point.left and
			  get_color_at(X, Y - 1) = color_id ) or

			( piece_point.right and
			  get_color_at(X, Y + 1) = color_id ) or

			( piece_point.bottom and
			  get_color_at(X + 1, Y) = color_id )
		then
			result := false
		end
	end

	is_piece_square_touch_correct_corners(X, Y:INTEGER; piece_point:G09_PIECE_POINT; color_id:INTEGER) : BOOLEAN
	-- check if this piece square touch corners of the same AT LEAST ONCE on one of the corners and not different color AND on other corners
	local
	top_left_correct, top_right_correct, bottom_left_correct, bottom_right_correct:BOOLEAN
	top_left_empty, top_right_empty, bottom_left_empty, bottom_right_empty:BOOLEAN
	do
--		if not piece_point.top_left and not piece_point.top_right and not piece_point.bottom_left and not piece_point.bottom_right then
--			-- this piece point isn't at any corner, return yes
--			--result:=true
--		else
--			-- assume that the piece touches wrong corner colors
--			result := false
--		end
		result:=false

		print(X)
		print(" ")
		print(Y)
		print(" ")
		print(get_color_at(X - 1, Y - 1))
		print(" ")
		print(color_id)
		print(" ")
		print(piece_point.top_left)
		print("%N")

		top_left_correct := get_color_at(X - 1, Y - 1) = color_id
		top_right_correct := get_color_at(X - 1, Y + 1) = color_id
		bottom_left_correct:= get_color_at(X + 1, Y - 1) = color_id
		bottom_right_correct := get_color_at(X + 1, Y + 1) = color_id

		top_left_empty := get_color_at(X - 1, Y - 1) = {G09_PLAYER_COLORS}.empty
		top_right_empty := get_color_at(X - 1, Y + 1) = {G09_PLAYER_COLORS}.empty
		bottom_left_empty := get_color_at(X + 1, Y - 1) = {G09_PLAYER_COLORS}.empty
		bottom_right_empty := get_color_at(X + 1, Y + 1) = {G09_PLAYER_COLORS}.empty

		if piece_point.top_left and (top_left_correct or top_left_empty) then
	    	result := result or top_left_correct
		end
		if piece_point.top_right and (top_right_correct or top_right_empty) then
	    	result := result or top_right_correct
		end
		if piece_point.bottom_left and (bottom_left_correct or bottom_left_empty) then
	    	result := result or bottom_left_correct
		end
		if piece_point.bottom_right and (bottom_right_correct or bottom_right_empty) then
	    	result := result or bottom_right_correct
		end

	end

	is_piece_touch_surrounding_colors_correctly(piece:G09_PIECE; color_id:INTEGER):BOOLEAN
	--Each new piece played must be placed so that it touches at least one piece of the same color, with only corner-to-corner contact allowed-edges cannot
	--touch. However, edge-to-edge contact is allowed when two pieces of different color are involved.	
	local
		i:INTEGER
		array_local:ARRAY[G09_POINT]
		array:ARRAY[G09_POINT]
	do
		--assume that the piece touch its surrounding colors correctly according to the game
		result:=true

		array_local := piece.get_points
	    array := piece.get_points_on_board

		from i:= array.lower until i>array.upper or not result
		loop
			if array.item (i) /= void then
				if not is_piece_square_touch_correct_edges(array.item (i).get_x, array.item (i).get_y,
					                                 piece.get_brick_at (array_local.item (i).get_x, array_local.item (i).get_y), color_id)
				then
					-- assumbison was wrong
					result:=false
				end
			end
			i:=i+1
		end
		if result then
			result:=false
			from i:= array.lower until i>array.upper
			loop
				if array.item (i) /= void then
					result:= result or is_piece_square_touch_correct_corners(array.item (i).get_x, array.item (i).get_y,
					                                 piece.get_brick_at (array_local.item (i).get_x, array_local.item (i).get_y), color_id)
				end
				i:=i+1
			end
		end
	end

feature -- Board queries update features
	get_color_at(X:INTEGER; Y:INTEGER): INTEGER
	-- get the color of square with X, Y coordinates on the baord
	do
		if X < 1 or X > 20 or Y < 1 or Y > 20 then
			result:={G09_PLAYER_COLORS}.empty
		else
			Result:= board.item(X, Y);
		end
	end

	get_score_of_color(color_id:INTEGER) : INTEGER
		-- gets the score of a color from the board
	do
		result := color_scores[color_id]
	end


feature{NONE} -- Board internal update features

	set_color_at(X:INTEGER; Y:INTEGER; color_id:INTEGER)
	do
	    board.item(X + 1, Y + 1) := color_id
	    raise_color_of_square_changed(X, Y, color_id)

		increment_score_of_color(color_id, 1)
	end

	increment_score_of_color(color_id:INTEGER; increment_value:INTEGER)
		-- add to the score of a color
	do
		color_scores[color_id] := color_scores[color_id] +  increment_value
		raise_score_of_color_changed (color_id, color_scores[color_id])
	end

feature{NONE} -- raise event
    raise_color_of_square_changed(x:INTEGER; y:INTEGER; color_id:INTEGER)
    do
        from color_of_square_color_changed.start until color_of_square_color_changed.after
        loop
            color_of_square_color_changed.item.notify_color_of_square_changed(x, y, color_id)
            color_of_square_color_changed.forth
        end
    end

    raise_score_of_color_changed(color_id:INTEGER; new_score:INTEGER)
    do
        from score_of_color_changed.start until score_of_color_changed.after
        loop
            score_of_color_changed.item.notify_score_of_color_changed(color_id, new_score)
            score_of_color_changed.forth
        end
    end

feature -- Events
	color_of_square_color_changed:LINKED_LIST[G09_COLOR_OF_SQUARE_CHANGED_LISTENER]
	score_of_color_changed:LINKED_LIST[G09_SCORE_OF_COLOR_CHANGED_LISTENER]

    -- returns a new board with the information contained by board
--    clone_board : G09_BOARD
--	local
--    do
--        Result := Current.deep_twin
--    end

    --Erase the piece from the board which have the color my_color
    erase(x: INTEGER; y: INTEGER; my_color: INTEGER)
    do
        if (board.item(x,y) = my_color)
        then
            board.item(x,y) := {G09_PLAYER_COLORS}.empty
            erase(x-1, y, my_color)
            erase(x+1, y, my_color)
            erase(x, y-1, my_color)
            erase(x, y+1, my_color)
        end
    end

feature{NONE} -- Implementation
	board:ARRAY2[INTEGER]
	color_scores:ARRAY[INTEGER]

end
