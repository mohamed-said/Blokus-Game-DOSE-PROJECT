note
	description: "Represents an abstract controller for the a player, can be a human player or an AI player."
	author: "Mohamed Kamal"
	date: "28.11.2013"
	revision: "1.0"

deferred class
	G09_ABSTRACT_PLAYER_CONTROLLER

inherit
	G09_CURRENT_PLAYER_CHANGED_LISTENER

feature -- Access
	get_color_id():INTEGER
	do
		result := my_color
	end

	get_game():G09_GAME
	do
		result := game
	end

	get_submitter():G09_MOVE_SUBMITTER_INTERFACE
	do
		result := submitter
	end

feature -- deferred (abstract) features to be implemented by children
	my_turn_started()
	deferred
	end

	my_turn_ended()
	deferred
	end

feature{G09_ABSTRACT_PLAYER_CONTROLLER} -- features visible to childs only
	set_color(color_id:INTEGER)
	do
		my_color := color_id
	end

	set_game(g:G09_GAME)
	do
		game := g
	end

	set_submitter(submitter_m:G09_MOVE_SUBMITTER_INTERFACE)
	do
		submitter := submitter_m
	end

feature{G09_LOGIC} -- Update status of the controller by LOGIC only
	activate()
	do
		game.current_player_changed_listeners.extend (current)
		is_active := true
	end

	deactivate()
	do
		if is_active then
			game.current_player_changed_listeners.search (current)
			game.current_player_changed_listeners.remove
			is_active := false
		end
	end

feature{NONE} -- Respond to GAME events and update turn status
	notify_current_player_changed(new_player:INTEGER)
	do
		if new_player = my_color then
			in_turn_now := true

			create timer.make_with_interval (15)
			timer.actions.extend (agent wait_then_start_my_turn)
		end

		if in_turn_now and new_player /= my_color then
			in_turn_now := false
			my_turn_ended()
		end
	end

	wait_then_start_my_turn()
	do
		print("%NPlayer Controller Turn will start%N")
		my_turn_started()
		timer.destroy

	end

feature{NONE} -- internal representation
	game:detachable G09_GAME
	my_color:INTEGER
	in_turn_now:BOOLEAN
	is_active:BOOLEAN
	submitter:G09_MOVE_SUBMITTER_INTERFACE
	timer: EV_TIMEOUT
end
