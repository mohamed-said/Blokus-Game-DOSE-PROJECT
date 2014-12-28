note
	description: "Interface for submitting a move of a player"
	author: "Mohamed Kamal"
	date: "29.11.2013"
	revision: "1.0"

deferred class
	G09_MOVE_SUBMITTER_INTERFACE

feature 
	submit_move(piece:G09_PIECE; color:INTEGER)
	-- submit a player move
	deferred
	end

end
