note
	description: "[
		Structure for sending messages over the network.
		Contains two fields:
		- type: INTEGER for describing what kind of message it is
		- object: ANY for containing additional information.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_INTERNAL_MESSAGE
	-- Only to be used by the NETWORK component, NOT the LOGIC!

inherit

	STORABLE

create
	make

feature -- Creation

	make (a_type: INTEGER; a_object: detachable ANY)
		do
			type := a_type
			object := a_object
		end

feature -- Status

	message_type: INTEGER
		do
			Result := type
		end

	message_object: ANY
		do
			Result := object
		end

feature -- Message types

	type_first_connect: INTEGER
		once
			Result := 0
		end

	type_client_connected: INTEGER
		once
			Result := 1
		end

	type_client_disconnected: INTEGER
		once
			Result := 2
		end

	type_client_name_changed: INTEGER
		once
			Result := 3
		end

	type_your_client_id: INTEGER -- Sent on first connection from server to the client
		once
			Result := 4
		end

	type_connected_clients: INTEGER
		once
			Result := 5
		end

	type_my_client_name: INTEGER -- Sent from the client to the server - results in "client name changed" event to all clients
		once
			Result := 6
		end

	type_turn_time_changed: INTEGER -- Can be sent by both the (master/host) client and the server
		once
			Result := 7
		end

	type_connect_AI: INTEGER
		once
			Result := 9
		end

	type_chat_message: INTEGER
		once
			Result := 8
		end

	type_start_game: INTEGER
		once
			Result := 10
		end

	type_game_update: INTEGER -- A game update which contains a G09_MESSAGE object
		once
			Result := 20
		end

	type_try_connection: INTEGER -- Used to send to see if connection is gone
		once
			Result := 666
		end

feature {NONE} -- Implementation

	type: INTEGER -- Must be one of the above message types

	object: detachable ANY

end
