note
	description: "Summary description for {G09_AI_RULES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	G09_AI_RULES

create
	make

feature{ANY}
	make
	do
		--Not implemented yet.
	end

	-- Puts the piece in the position named "pos" in the board.
	-- Returns true iff the rule is applicable.
	rule_put_the_piece(board: G09_BOARD; player: G09_PLAYER; pos: G09_POINT; piece: G09_PIECE): BOOLEAN
	do
		Result:= board.can_add_piece(pos.get_x, pos.get_y, piece, player.get_color_id)
	end

	-- Turns the piece once and puts it in the position named "pos" in the board.
	-- Returns true iff the rule is applicable.
	rule_turn_once(board: G09_BOARD;  player: G09_PLAYER; pos: G09_POINT; piece: G09_PIECE): BOOLEAN
	do
		--Turn the piece once.
		--piece.turn();
		Result:= board.can_add_piece(pos.get_x, pos.get_y, piece, player.get_color_id)
	end

	-- Turns the piece twice and puts it in the position named "pos" in the board.
	-- Returns true iff the rule is applicable.
	rule_turn_twice(board: G09_BOARD;  player: G09_PLAYER; pos: G09_POINT; piece: G09_PIECE): BOOLEAN
	do
		--Turn the piece twice.
		--piece.turn();
		Result:= board.can_add_piece(pos.get_x, pos.get_y, piece, player.get_color_id)
	end

	-- Turns the piece three times and puts it in the position named "pos" in the board.
	-- Returns true iff the rule is applicable.
	rule_turn_three_times(board: G09_BOARD;  player: G09_PLAYER; pos: G09_POINT; piece: G09_PIECE): BOOLEAN
	do
		--Turn the piece three times.
		--piece.turn();
		Result:= board.can_add_piece(pos.get_x, pos.get_y, piece, player.get_color_id)
	end

end
