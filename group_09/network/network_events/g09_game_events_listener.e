note
	description: "Summary description for {G09_GAME_EVENTS_LISTENER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
G09_GUI_GAME_EVENTS_LISTENER


feature -- Client events (player)

	notify_game_starts()
		deferred
		end

	notify_game_over()
		-- Used when the game ends, either because of game play is over or because the connection was lost
		deferred
		end

	notify_client_connected(id: INTEGER; name: STRING)
		deferred
		end

	notify_client_name_changed(id: INTEGER; new_name: STRING)
		deferred
		end

	notify_client_disconnected(id: INTEGER)
		deferred
		end


feature -- Game settings

	notify_turn_time_changed(seconds: INTEGER)
		deferred
		end

feature -- Chat message

	notify_chat_message_received(client_id: INTEGER; client_name: STRING; message: STRING)
		deferred
		end
end
