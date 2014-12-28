note
	description : "group_09_deidcated_server application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	G09_DEDICATED_SERVER

inherit
	ARGUMENTS
	G09_GUI_GAME_EVENTS_LISTENER

create
	make

feature {NONE} -- Initialization

	network: attached G09_NETWORK

	make
		do
			create network.make(Current)
			network.host_game (1500)
		end

	notify_client_connected(id: INTEGER; name: STRING)
		do
		end

	notify_client_name_changed(id: INTEGER; new_name: STRING)
		do
		end

	notify_client_disconnected(id: INTEGER)
		do
		end


	notify_turn_time_changed(seconds: INTEGER)
		do
		end


	notify_game_update(id: INTEGER; object: ANY)
		do
		end

	notify_chat_message_received(client_id: INTEGER; client_name: STRING; message: STRING)
		do
		end
	notify_game_starts
		do
		end
	notify_game_over
		do
		end

	piece: G09_PIECE
	piece_point: G09_PIECE_POINT
end
