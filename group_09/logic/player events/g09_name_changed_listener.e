note
	description: "Listener for 'Player name changed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_NAME_CHANGED_LISTENER

feature -- notified functions

	notify_name_changed(new_name:STRING)
	deferred
	end

end
