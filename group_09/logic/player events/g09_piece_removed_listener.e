note
	description: "Listener for 'piece removed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_PIECE_REMOVED_LISTENER

feature -- notified functions
	
	notify_piece_removed(removed_piece:INTEGER)
	deferred
	end

end
