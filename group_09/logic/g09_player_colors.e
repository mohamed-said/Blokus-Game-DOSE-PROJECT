note
	description: "Represents the game board for blockus game."
	author: "Mohamed Kamal"
	date: "$Date: 05-11-2013$"
	revision: "$Revision: 1.0$"

class
	G09_PLAYER_COLORS

feature -- Player colors constants
		-- used like this: feature{G09_PLAYER_COLORS}.blue
		-- this is the best way we found

	blue:INTEGER = 1
	yellow:INTEGER = 2
	red:INTEGER = 3
	green:INTEGER = 4
	empty:INTEGER = 5


	start_score:INTEGER = 0		-- sum of all sqaures of all pieces in a piece set
	final_score:INTEGER = 89
end
