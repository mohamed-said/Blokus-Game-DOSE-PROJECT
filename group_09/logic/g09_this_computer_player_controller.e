note
	description: "Represents a controller for the current computer human player."
	author: "Mohamed Kamal"
	date: "28.11.2013"
	revision: "1.1"

class
	G09_THIS_COMPUTER_PLAYER_CONTROLLER

	--The class automatically detects if the turn now is for the
	--human player on this computer and gives the green light to GUI
	--to allow the player to make his move and recieve that move to
	--be updated in the game

inherit
	G09_ABSTRACT_PLAYER_CONTROLLER

create
	make_controller_with_GUI

feature{NONE} -- Initialization
	make_controller_with_GUI(player_color:INTEGER;g:G09_GAME; submitter_m:G09_MOVE_SUBMITTER_INTERFACE)
	do
		create can_play_listeners.make
		create host_move_validation_failed.make
		set_game (g)
		set_color (player_color)
		set_submitter (submitter_m)

	end

feature -- Implement parent features
	my_turn_started()
	do
		set_can_play(true)
	end

	my_turn_ended()
	do
		set_can_play(false)
	end

feature -- Access
	get_can_play():BOOLEAN
	do
		result:=can_play
	end

feature{G09_LOGIC} -- Update status by LOGIC only
	alert_last_move_failed()
	do
		raise_host_move_validation_failed()
	end

feature{NONE} -- internal setters
	set_can_play(can_play_m:BOOLEAN)
	do
		can_play := can_play_m
		raise_can_play_changed (can_play_m)
	end

feature{NONE} -- raise events features
	raise_can_play_changed(new_can_play:BOOLEAN)
	do
		from can_play_listeners.start until can_play_listeners.after
		loop
			can_play_listeners.item.notify_can_play_changed(new_can_play)
			can_play_listeners.forth
		end
	end

	raise_host_move_validation_failed()
	do
		from host_move_validation_failed.start until host_move_validation_failed.after
		loop
			host_move_validation_failed.item.notify_host_move_validation_failed()
			host_move_validation_failed.forth
		end
	end

feature -- Events
	can_play_listeners:LINKED_LIST[G09_CAN_PLAY_CHANGED_LISTENER]
	host_move_validation_failed:LINKED_LIST[G09_HOST_MOVE_VALIDATION_FAILED_LISTENER]

feature{NONE} -- Implementation
	can_play:BOOLEAN

end
