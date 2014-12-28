note
	description: "Listener for 'Can Play Changed' event in 'THIS_COMPUTER_PLAYER'"
	author: "Mohamed Kamal"
	date: "$Date: 07-11-2013$"
	revision: "$Revision: 1.0$"

deferred class
	G09_CAN_PLAY_CHANGED_LISTENER

feature{ANY} -- Initlization
	notify_can_play_changed(new_can_play:BOOLEAN)
	deferred
	end

end
