note
	description: "Listener for 'Time Left Timer Changed' event"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_HOST_MOVE_VALIDATION_FAILED_LISTENER

feature{ANY} -- Initlization
	notify_host_move_validation_failed()
	deferred
	end

end
