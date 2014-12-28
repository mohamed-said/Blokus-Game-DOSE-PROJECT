note
	description: "Listener for 'Current Player Changed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_CURRENT_PLAYER_CHANGED_LISTENER

feature -- notified functions
	notify_current_player_changed(new_player:INTEGER)
	-- notify that the turn of a player has finished and now another player turn is starting
	-- GUI: can be changed to take the color id instead, it is up to your preference
	deferred
	end

end
