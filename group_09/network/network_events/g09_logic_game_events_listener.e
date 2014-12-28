note
	description: "Summary description for {G09_LOGIC_GAME_EVENTS_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	G09_LOGIC_GAME_EVENTS_LISTENER

feature -- Gameplay

	notify_game_update(id: INTEGER; object: ANY)
		deferred
		end

notify_client_name_changed(id: INTEGER; new_name: STRING)
		deferred
		end

	notify_client_disconnected(id: INTEGER)
		deferred
		end

end
