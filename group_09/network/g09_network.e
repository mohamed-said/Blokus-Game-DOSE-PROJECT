note
	description: "[
		Main network class exposing API for the LOGIC and GUI. 
		Only interface between network and 'outer world'.
	]"
	author: "Martin Marcher"
	date: "$Date$"
	revision: "$Revision$"

class
	G09_NETWORK

inherit

	INET_ADDRESS_FACTORY

create
	make

feature -- Instantiate

	make (a_listener: G09_GUI_GAME_EVENTS_LISTENER)
		do
			gui_listener := a_listener
			create ref_msg.make (-1, Void)
		ensure
			not_started: not is_started
		end

feature -- Connection

	host_game (port: INTEGER)
		require
			not_started: not is_started
			port_valid: port > 0
		do
			my_id := 1
			create clients.make (4)
			create server.make_server (port, Current)
			server.execute
		ensure
			is_started: is_started
			is_host: is_host
			right_port: port_number = port
			right_client_id: my_client_id = 1
		end

	join_game (ip: STRING; port: INTEGER)
		require
			not_started: not is_started
			ip_not_void: ip /= Void and then not ip.is_empty
			port_not_void: port > 0
		do
			my_id := -1
			create clients.make (4)
			create client.make_client (ip, port, Current)
			wait_for_client_id
			wait_for_connected_clients
			from
				clients.start
			until
				clients.after
			loop
				gui_listener.notify_client_name_changed (clients.key_for_iteration, clients.item_for_iteration)
				clients.forth
			end
			start_timer
		ensure
			is_started: is_started
				--is_client: not is_host
			some_client_id: 0 < my_client_id and my_client_id <= 4
		end

	disconnect
		require
			is_started: is_started
		do
			if (server /= Void) then
				server.close
				server := Void
			else
				stop_timer
				client.close
				client := Void
			end
			clients := Void
		ensure
			not is_started
		end

feature -- Listener

	set_gui_listener (a_listener: attached G09_GUI_GAME_EVENTS_LISTENER)
		do
			gui_listener := a_listener
		end

	set_logic_listener (a_listener: attached G09_LOGIC_GAME_EVENTS_LISTENER)
		do
			logic_listener := a_listener
		end

feature -- Status

	my_ip: STRING -- Probably only works in Windows?
		local
			ip: INET_ADDRESS
		do
			ip := create_localhost
			Result := ip.host_address
		end

	is_started: BOOLEAN
		do
			Result := server /= Void or else client /= Void
		end

	is_host: BOOLEAN
		require
			is_started: is_started
		do
			Result := my_client_id = 1 -- With dedicated server
				--Result := server /= Void --Without dedicated server
		end

	port_number: INTEGER
		require
			is_host: is_started
		do
			Result := server.port
		end

	my_client_id: INTEGER
		require
			is_started: is_started
		do
			Result := my_id
		end

	connected_clients: HASH_TABLE [STRING, INTEGER] --[Client name, client id]
		require
			is_started: is_started
		do
			Result := clients
		end

feature -- Update

	look_for_updates
			-- Blocking
			-- Look for any updates from server/other clients
		require
			is_started: is_started
		do
			if server /= Void then
				server.look_for_updates
			else
				client.look_for_updates
			end
		end

feature -- Lobby activity

	start_game
		do
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_start_game, Void))
		end

	change_my_name (new_name: STRING)
		require
			valid_name: new_name /= Void and then not new_name.is_empty
		do
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_my_client_name, new_name))
		end

	change_client_name (client_id: INTEGER; new_name: STRING)
		require
			is_host_or_myself: is_host or else client_id = my_client_id
			valid_id: 1 <= client_id and client_id <= 4
			client_connected: connected_clients.has (client_id)
			valid_name: new_name /= Void and then not new_name.is_empty
		local
			l_tuple: TUPLE [id: INTEGER; name: STRING]
		do
			create l_tuple.default_create
			l_tuple.id := client_id
			l_tuple.name := new_name
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_client_name_changed, l_tuple))
		end

	change_turn_time (time_in_seconds: INTEGER)
		require
			is_host: is_host
		do
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_turn_time_changed, time_in_seconds))
		end

	add_AI_player (seat, level: INTEGER)
		require
			valid_seat: 2 <= seat and seat <= 4
			free_seat: not connected_clients.has (seat)
		local
			l_tup: TUPLE [seat: INTEGER; level: INTEGER]
		do
			create l_tup.default_create
			l_tup.seat := seat
			l_tup.level := level
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_connect_ai, l_tup))
		end

	kick_client (id: INTEGER)
		require
			is_host: is_host
			valid_id: 2 <= id and id <= 4 -- You can't kick yourself, mkay?
			client_connected: connected_clients.has (id)
		do
			check
				Not_implemented: False
			end
		end

feature -- Chat messages

	send_chat_message (message: attached STRING)
		require
			is_started: is_started
		local
			l_tup: TUPLE [id: INTEGER; msg: STRING]
		do
			create l_tup.default_create
			l_tup.id := my_id
			l_tup.msg := message
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_chat_message, l_tup))
		end

feature -- Game functionality

	send_game_update (id: INTEGER; object: ANY)
		require
			is_started: is_started
		local
			l_tup: TUPLE [id: INTEGER; object: ANY]
		do
			create l_tup.default_create
			l_tup.id := id
			l_tup.object := object
			send (create {G09_INTERNAL_MESSAGE}.make (ref_msg.type_game_update, l_tup))
		end

feature {G09_NETWORK_CLIENT, G09_NETWORK_SERVER}

	recieve_internal_message (msg: G09_INTERNAL_MESSAGE)
		do
			if msg.message_type = msg.type_client_connected then
				if attached {TUPLE [id: INTEGER; name: STRING]} msg.message_object as obj then
					clients.put (obj.name, obj.id)
					gui_listener.notify_client_connected (obj.id, obj.name)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_client_disconnected then
				if attached {INTEGER} msg.message_object as obj then
					clients.remove (obj)
					gui_listener.notify_client_disconnected (obj)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_client_name_changed then
				if attached {TUPLE [id: INTEGER; name: STRING]} msg.message_object as obj then
					clients.at (obj.id) := obj.name
					gui_listener.notify_client_name_changed (obj.id, obj.name)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_your_client_id then
				if attached {INTEGER} msg.message_object as obj then
					my_id := obj
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_connected_clients then
				if attached {HASH_TABLE [STRING, INTEGER]} msg.message_object as obj then
					clients := obj
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_turn_time_changed then
				if attached {INTEGER} msg.message_object as obj then
					gui_listener.notify_turn_time_changed (obj)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_start_game then
				gui_listener.notify_game_starts
			elseif msg.message_type = msg.type_game_update then
				if attached {TUPLE [id: INTEGER; object: ANY]} msg.message_object as obj then
					if logic_listener /= Void then
						logic_listener.notify_game_update (obj.id, obj.object)
					end
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_chat_message then
				if attached {TUPLE [id: INTEGER; message: STRING]} msg.message_object as obj then
					gui_listener.notify_chat_message_received (obj.id, connected_clients.at (obj.id), obj.message)
				else
					check
						Wrong_object_structure: False
					end
				end
			elseif msg.message_type = msg.type_try_connection then
					-- Just ignore this
			else
				check
					Unknown_type: False
				end
			end
		end

	notify_connection_lost
		do
			disconnect
			gui_listener.notify_game_over
		end

feature {NONE} -- Implementation

	start_timer
		do
			create timer.make_with_interval (100)
			timer.actions.extend (agent look_for_updates)
		end

	stop_timer
		do
			timer.set_interval (0)
			timer := Void
		end

	send (msg: attached G09_INTERNAL_MESSAGE)
		require
			is_started: is_started
		do
			if server /= Void then
				server.send (msg)
			else
				client.send (msg)
			end
		end

	wait_for_client_id
			-- Blocking
		do
			from
			until
				my_id > -1 --Busy wait
			loop
				look_for_updates
			end
		ensure
			client_id_set: my_client_id > -1
		end

	wait_for_connected_clients
			-- Blocking
		do
			from
			until
				connected_clients /= Void and then connected_clients.has (1) -- Busy wait
			loop
				look_for_updates
			end
		ensure
			connected_clients_set: connected_clients /= Void and then connected_clients.count > 0
		end

	client_id_set, connected_clients_set: BOOLEAN

	client: detachable G09_NETWORK_CLIENT

	server: detachable G09_NETWORK_SERVER

	clients: detachable HASH_TABLE [STRING, INTEGER]

	timer: EV_TIMEOUT

	my_id: INTEGER

	ref_msg: attached G09_INTERNAL_MESSAGE -- used for references to message types

	gui_listener: attached G09_GUI_GAME_EVENTS_LISTENER

	logic_listener: detachable G09_LOGIC_GAME_EVENTS_LISTENER

invariant
	not_both_server_and_client: client = Void or server = Void

end
