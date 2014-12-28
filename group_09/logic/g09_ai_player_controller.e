note
	description: "Represents an ai player controller"
	author: "Mohamed Kamal"
	date: "28.11.2013"
	revision: "1.0"

class
	G09_AI_PLAYER_CONTROLLER

inherit
	G09_ABSTRACT_PLAYER_CONTROLLER

create
	make_controller_with_AI

feature{ANY} -- Initialization
	make_controller_with_AI(color_id:INTEGER; g:G09_GAME; submitter_m:G09_MOVE_SUBMITTER_INTERFACE; difficulty_m:INTEGER)
	-- create a player controller for an AI component
	do
		difficulty:=difficulty_m
		set_game (g)
		set_color (color_id)
		set_submitter (submitter_m)
		
		create ai.make_ai_with_game (g)
	end

feature -- Implement parent features
	my_turn_started()
	local
	piece:G09_PIECE
	do
		piece:= ai.best_play(difficulty)

		if game.get_board.can_add_game_piece (piece, my_color) = -1 then
		-- if the piece returned by the AI is invalid, pass my turn
			piece := void
		end
		submitter.submit_move(piece,my_color)
	end

	my_turn_ended()
	do

	end

feature{NONE} -- Internal represntation
	difficulty:INTEGER
	ai:G09_AI
end
