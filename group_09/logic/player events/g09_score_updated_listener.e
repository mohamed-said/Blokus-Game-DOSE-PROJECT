note
	description: "Listener for 'piece removed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_SCORE_UPDATED_LISTENER

feature -- notified functions

	notify_score_updated(removed_piece_id:INTEGER)
	deferred
	end

end
