note
	description: "Summary description for {G09_PIECE_POINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_PIECE_POINT

create
	make_empty

feature{NONE} -- Initialization
	make_empty()
	do
		empty:=true
		create flags.make_filled (false, 1, 8)
	end

feature{G09_BOARD, G09_PIECE} -- Checking flags for a brick to each of its neighbours bricks
				   -- Used by the board

	is_empty():BOOLEAN
	do
		result := empty
	end

	enable_inner_brick()
	do
		empty := false
	end

 --and {G09_PIECE_BRICKS_CONSTANTS}.
	top_left():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.top_left_edge)
	end

	top():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.top_edge)
	end

	top_right():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.top_right_edge)
	end

	left():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.left_edge)
	end

	right():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.right_edge)
	end

	bottom_left():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.bottom_left_edge)
	end

	bottom():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.bottom_edge)
	end

	bottom_right():BOOLEAN
	do
		result:=flags.item({G09_PIECE_BRICKS_CONSTANTS}.bottom_right_edge)
	end

	enable_must_be_checked(flag:INTEGER;)
	do
		flags.put(true, flag)
		if empty = true then
			empty := false
		end
	end

	enable_topleft_top_left()
	do
		enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_left_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.left_edge)
	end

	enable_topright_top_right()
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_right_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.right_edge)
	end

	enable_bottomleft_bottom_left
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.left_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_left_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_edge)
	end

	enable_bottomright_bottom_right
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.right_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_right_edge)
	end

	enable_top_bottom
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_edge)
	end

	enable_left_right
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.left_edge)
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.right_edge)
	end

	enable_left
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.left_edge)
	end

	enable_right
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.right_edge)
	end

	enable_top
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.top_edge)
	end

	enable_bottom
	do
	    enable_must_be_checked({G09_PIECE_BRICKS_CONSTANTS}.bottom_edge)
	end

	rotate_clockwise
	local
		i:INTEGER
		temp_end:BOOLEAN
	do
		temp_end := flags.item (flags.upper)
		from i := flags.lower
		until
			i > flags.upper - 1
		loop
			flags.put (flags.item (i), i+1)
			i:=i+1
		end
		flags.put (temp_end, 1)
	end

	rotate_anticlockwise
	local
		i:INTEGER
		temp_end:BOOLEAN
	do
		temp_end := flags.item (1)
		from i := flags.lower + 1
		until
			i > flags.upper
		loop
			flags.put (flags.item (i), i-1)
			i:=i+1
		end
		flags.put (temp_end, flags.upper)
	end

feature{G09_PIECE}
	flags:ARRAY[BOOLEAN]
	empty:BOOLEAN
end
