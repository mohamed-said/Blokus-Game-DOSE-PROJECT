note
	description: "Summary description for {G09_GENERAL_GUI_EVENTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class -- class G09_GENERAL_GUI_EVENTS for Logic
	G09_GENERAL_GUI_EVENTS

-- Events for Logic
feature
	notify_host_game()
		deferred
		end

	notify_user_set_turn_time()
		deferred
		end

	notify_join_game()
		deferred
		end

	notify_begin_game()
		deferred
		end

	notify_player_disconnected()
		deferred
		end

	notify_add_ai_player()
		deferred
		end

	notify_name_changed (new_name: STRING)
		deferred

		end

end

